(local {:get_location navic-location
        :is_available navic-available?} (require :nvim-navic))

(local {:api {:nvim_get_mode api/get-mode}
        :lsp {:get_active_clients lsp/get-active-clients}} vim)

(fn nil? [x]
  (= x nil))

(fn map [xs func]
  (icollect [_ x (ipairs xs)]
    (func x)))

(fn -># [x func]
  "Define function and apply the argument to it. Useful in (->) forms."
  (func x))

;; highlight group names
;; Main and Alt hightlight groups
(local hl-main "StatusLine")
(local hl-alt  "StatusLineAlt")
;; StatusLineMode$X for highlighting different modes
(local hl-normal  "StatusLineModeNormal")
(local hl-insert  "StatusLineModeInsert")
(local hl-visual  "StatusLineModeVisual")
(local hl-replace "StatusLineModeReplace")

(fn hl-esc [hl]
  "escape highlight group for status line"
  (.. "%#" hl "#"))

;; mapping from short mode names to full names and optional highlight groups
(local mode-printname
  {;; normal modes
   :n   {:name "normal"       :hl hl-normal}
   :no  {:name "n·op·pending" :hl hl-normal}
   ;; visual modes
   :v   {:name "visual"       :hl hl-visual}
   :V   {:name "v·line"       :hl hl-visual}
   "" {:name "v·block"      :hl hl-visual}
   ;; insert mode
   :i   {:name "insert"       :hl hl-insert}
   ;; replace modes
   :R   {:name "replace"      :hl hl-replace}
   :Rv  {:name "v·replace"    :hl hl-replace}
   ;; rest of the modes
   ;; these are all taken from some other plugin, don't really know what they
   ;; all actually do
   :s   {:name "select"}
   :S   {:name "s·line"}
   "" {:name "s·block"}
   :c   {:name "command"}
   :cv  {:name "vim·ex"}
   :ce  {:name "ex"}
   :r   {:name "prompt"}
   :rm  {:name "more"}
   :r?  {:name "confirm"}
   :!   {:name "shell"}
   :t   {:name "terminal"}})

(fn fmt-mode [mode-short]
  "format mode for status line"
  (local hl-default hl-normal)
  (-> mode-printname
      (. mode-short)
      (match
        ;; name and hl group -> use all
        {: name : hl} {: name : hl}
        ;; just name -> default hl group
        {: name}      {: name :hl hl-default}
        ;; otherwise -> default hl group and raw mode name
        _             {:name mode-short :hl hl-default})
      (-># #(.. (hl-esc $1.hl)
                " "
                $1.name))))

(fn fmt-lsp [clients]
  "format attached lsp clients for status line"
  (-> (if (nil? clients) 0  ;; grab number of clients in a nil-safe way.
          (length clients))
      (match
        ;; no clients -> empty string
        0 ""
        ;; less or equal than three clients -> comma separated names
        (where n (<= n 3)) (-> clients
                               (map #$1.name)
                               (table.concat ","))
        ;; more than three clients -> just print the number of clients
        _ (tostring n))))

(fn fmt-segments [segments]
  "format segments in the status line"

  (fn fmt [{: s : hl}]
    "fmt a single segment of {:s text :hl opt-hl?}"
    (if (nil? hl) s          ;; no hl specifier, just the text
        (.. (hl-esc hl) s))) ;; or include the hl specifier too, escaped

  (fn reduce [xs func]
    "reduce by table.concat"
    (-> xs
        (map func)
        (table.concat " ")))

  (reduce segments #(reduce $1 fmt)))

(fn statusline []
  "string for current statusline"
  (let [;; Left side: vim mode and LSP outline (if available).
        left (let [mode {:s (-> (api/get-mode)
                                (. :mode)
                                (fmt-mode))}
                   navic (when (navic-available?)
                           {:s (.. " " (navic-location))
                            :hl hl-main})]
               [mode navic])

        ;; Separator in the middle, pushing left and right side to each end.
        sep [{:s "%=" :hl hl-main}]

        ;; Right side: LSP clients and file specifics.
        right (let [hl-set {:s ""
                            :hl hl-alt}
                    lsp (-> (lsp/get-active-clients)
                            (fmt-lsp)
                            (-># #(when (not= $1 "")
                                        (.. "lsp:" $1)))
                            (-># #{:s $1}))
                    pos {:s "pos:[%l:%c:%p%%]"}
                    ft {:s (.. "ft:" vim.bo.filetype)}]
                [hl-set lsp pos ft])]

    (fmt-segments [left sep right])))

{: statusline}
