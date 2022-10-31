(local Job (require :plenary.job))
(local curl (require :plenary.curl))
(local {: split
        : cut} (require :skr.std))

(local {:api {:nvim_create_buf      create-buf
              :nvim_buf_set_option  buf-set-opt
              :nvim_buf_set_lines   buf-set-lines
              :nvim_buf_get_lines   buf-get-lines
              :nvim_win_set_buf     win-set-buf
              :nvim_get_current_buf get-current-buf
              :nvim_get_current_win get-current-win}
        : json
        :tbl_flatten flatten} vim)

(local delim-query "# ---query---")
(local delim-resp  "# ---response---")

(fn json-pretty-print [json]
  "Pretty print a json string via jq."
  (let [(out code) (-> {:command :jq
                        :writer json}
                       (Job:new)
                       (: :sync))
        ok? (= code 0)]
    (if ok? out
        (error (.. "jq exited with code " code)))))

(fn parse [lines]
  (fn pcut [str delim]
    (pcall cut str delim))

  (-> lines
      ;; Cut at the delim-query line, which should be the first line
      (pcut delim-query)
      ;; Check if it was successful
      (match
        (true [_ after]) after
        (false _) (error "missing query delimiter"))
      ;; Cut again at the delim-resp line, which should now separate the query
      ;; from the response
      (pcut delim-resp)
      ;; Check again if it was successful
      (match
        (true [query resp]) {:query (table.concat query "\n")
                             :resp  (table.concat resp "\n")}
        (false _) (error "missing resp delimiter"))))

(fn write [buf {: query : resp}]
  (let [query-lines (split query "\n")
        resp-lines (json-pretty-print resp)
        lines (flatten [delim-query
                        query-lines
                        delim-resp
                        resp-lines])]
    (buf-set-lines buf 0 -1 false lines)))


(fn read-token []
  "Read the authorization token."
  (fn read [file]
    "Read the json body from the locally cached file."
    (let [[body] (-> {:command "cat"
                      :args [file]
                      :enable_recording true}
                      (Job:new)
                      (: :sync))]
      (json.decode body)))

  (fn refresh []
    "Run a new login command to fetch a new token."
    (-> {:command "nclogin"
         :args ["-stage" "prod"]}
         (Job:new)
         (: :sync)))

  (fn parse-time [str]
    "Parses a RFC3339 datetime string, down to seconds precision."
    (let [pattern "^(%d%d%d%d)-(%d%d)-(%d%d)T(%d%d):(%d%d):(%d%d)"
          (_ _ year month day hour min sec) (string.find str pattern)]
      (os.time {: year
                : month
                : day
                : hour
                : min
                : sec})))

  (let [;; Expand the home directory for the locally cached file.
        file (vim.fn.expand "~/.nclogin/prod-creds.json")

        ;; Read, parse, and unpack the token and its expiry date.
        {:id_token token
         :expires_at expiry} (read file)

        ;; Parse the expiry date and compare to now.
        expires-at (parse-time expiry)
        now (os.time)
        is-valid? (< now expires_at)]

    ;; Either return the token if it still is valid, or refresh it and retry.
    (if is-valid? token
        (do
          (refresh)
          (read-token)))))

(fn send-query [query]
  (let [;; Read token from local cache.
        token (read-token)

        ;; Construct query via curl.
        url "https://api.northvolt.com/graphql"
        body (json.encode {: query})
        raw ["--header" (.. "Authorization: Bearer " token)
             "--header" "Content-Type: application/json; charset=utf-8"
             "--header" "Accept: application/json; charset=urf-8"]]

      ;; Post the query.
      (curl.post {: url
                  : body
                  : raw})))

(fn start []
  (let [;; Create new buffer for the querying
        buf (create-buf true true)
        ;; We want to set the buffer to the current window, so get that
        win (get-current-win)
        ;; The initial state we want to write to the buffer
        state {:query "query {\n}"
               :resp ""}]

    (do
      ;; Update the buffer of the window
      (win-set-buf win buf)
      ;; Set the filetype so we get syntax highlighting
      (buf-set-opt buf :filetype :graphql)
      ;; Write the initial state to the buffer
      (write buf state))))

(fn post []
  (let [buf (get-current-buf)
        ;; Parse the query from the buffer
        query (-> buf
                  (buf-get-lines 0 -1 false)
                  (parse)
                  (. :query))
        ;; Send the request and get back the resp body
        resp (-> query
                 (send-query)
                 (. :body))
        ;; Construct new state
        new-state {: query : resp}]

    ;; Write out the state
    (write buf new-state)))

{: start
 : post}
