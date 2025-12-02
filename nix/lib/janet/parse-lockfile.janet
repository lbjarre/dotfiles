# parse-lockfile.janet: nix utility to convert jpm dependencies to nix.
# If the source has a lockfile.jdn at its root this is parsed and converted,
# else an empty list is emitted.

(defn lockfile->nix [f lockfile]
  (file/write f "[")
  (each entry lockfile
    (def {:url url :tag tag :type btype} entry)
    (file/write f (string ` { url = "` url `"; rev = "` tag `"; }`)))
  (file/write f " ]"))

(defn path/join [args] (string/join args "/"))

(defn main [& args]
  (def [src out] (match args
                   [_ src out] [src out]
                   _ (error "missing required args")))
  (def lockfile (path/join [src "lockfile.jdn"]))
  (with [f (file/open out :w)]
    (if (os/stat lockfile)
      (lockfile->nix f (parse (slurp lockfile)))
      (file/write f "[]"))))
