(import spork/http)
(import jsec/tls)

(defn id [x] x)
(defn not-empty? [x] (not= (length x) 0))
(defn parse-int [str]
  (def x (parse str))
  (if (int? x) x (error "not an integer")))

# Options for the script settable via environment variables.
# Each object is configured with:
#
#   :name       string                  name of the option in the final parsed output struct
#   :env        string                  name of the environment variable key to read value from
#   :default    T | fn(): T             default value to use if the environment variable is not set
#   :parse      fn(string): T | nil     optional function to parse the environment variable
#
(def OPTS [{:name    :cache-file
            :env     "WTTR_CACHE"
            :default |(string (os/getenv "HOME") "/.cache/wttr/cached.jdn")}
           {:name    :cache-ttl
            :env     "WTTR_CACHE_TTL"
            :default 300
            :parse   parse-int}
           {:name    :fmt
            :env     "WTTR_FMT"
            :default "%c+%t+(%f)+%p"}
           {:name    :url
            :env     "WTTR_URL"
            :default "https://wttr.in"}
           {:name    :debug?
            :env     "WTTR_DEBUG"
            :default false
            :parse   not-empty?}
           {:name    :timeout
            :env     "WTTR_TIMEOUT"
            :default 10
            :parse   parse-int}])

(defn parse-opts
  "Parse options from environment."
  [opts]
  (defn parse-opt
    "Parse a single option."
    [{:name name
      :env env
      :default default-value
      :parse parse-value}]
    (def raw-value (os/getenv env))
    (def value (if raw-value
                   ((or parse-value id) raw-value)
                   (if (function? default-value)
                       (default-value)
                       default-value)))
    {:name name
     :value value})
  # Parse and collect each option into a table.
  (def out @{})
  (each opt opts
    (def p (parse-opt opt))
    (put out (p :name) (p :value)))
  (table/to-struct out))

(defn read-cfg [key] ((dyn :cfg) key))

(defn log [msg & args] (if (read-cfg :debug?) (eprintf msg ;args)))

(defn decode
  "Decode string/buffer into Janet value."
  [b]
  (def p (parser/new))
  (parser/consume p b)
  (parser/eof p)
  (cond
    (= (parser/status p) :error) (error (parser/error p))
    (not (parser/has-more p)) (error "expected at least one value")
    (parser/produce p)))

(defn encode
  "Encode Janet value to a string"
  [v]
  (string/format "%j" v))

(defn read-cache
  "Read the cached value from disk, and return it if the TTL has not expired yet."
  []
  (def cache-file (read-cfg :cache-file))
  (def cache-ttl (read-cfg :cache-ttl))
  (def now (dyn :now))
  (def {:fetched-at fetched-at :value value} (decode (slurp cache-file)))
  (def diff (- now (or fetched-at 0)))
  (def hit (< diff cache-ttl))
  (log "cache: hit=%j fetched-at=%j now=%j diff=%j" hit fetched-at now diff)
  (cond
    (not hit) (error "cache expired")
    (compare= value "") (error "empty value")
    value))

(defn write-cache
  "Write the value to disk for caching."
  [v]
  (def cache-file (read-cfg :cache-file))
  (def now (dyn :now))
  (->> {:fetched-at now :value v}
       (encode)
       (spit cache-file)))

(defn fetch-wttr
  "Do HTTP call towards wttr API."
  []
  (def url (string (read-cfg :url) "/?format=" (read-cfg :fmt)))
  (log "fetch: url=%j" url)
  # TODO: double free when this gets cancelled, presumably from the tls layer.
  (ev/with-deadline (read-cfg :timeout)
      (def resp (http/request "GET" url :stream-factory tls/connect))
      (http/read-body resp)))

(defn main [& args]
  (setdyn :cfg (parse-opts OPTS))
  (setdyn :now (os/clock :realtime :int))

  # Try first to read value from cache.
  (match (protect (read-cache))
    [true cached] (do (prin cached)
                      (os/exit 0))
    [false err] (log "read-cache failed err=%j" err))

  # If cache failed, fetch from service.
  (match (protect (fetch-wttr))
    [true resp] (do (write-cache resp)
                    (prin resp))
    [false err] (log "fetch-wttr failed err=%j" err)))
