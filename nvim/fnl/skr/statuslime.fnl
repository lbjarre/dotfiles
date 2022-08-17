(local {:get_location gps-location
        :is_available gps-available?}
    (require :nvim-gps))

;; highlight group names
(local hl
  {;; StatusLineMode$X for highlighting different modes
   :normal  "StatusLineModeNormal"
   :insert  "StatusLineModeInsert"
   :visual  "StatusLineModeVisual"
   :replace "StatusLineModeReplace"
   ;; Main and Alt hightlight groups
   :main    "StatusLine"
   :alt     "StatusLineAlt"})

;; mapping from short mode names to full names and optional highlight groups
(local modes-printnames
  {;; normal modes
   :n   {:name "normal"       :hl hl.normal}
   :no  {:name "n·op·pending" :hl hl.normal}
   ;; visual modes
   :v   {:name "visual"       :hl hl.visual}
   :V   {:name "v·line"       :hl hl.visual}
   "" {:name "v·block"      :hl hl.visual}
   ;; insert mode
   :i   {:name "insert"       :hl hl.insert}
   ;; replace modes
   :R   {:name "replace"      :hl hl.replace}
   :Rv  {:name "v·replace"    :hl hl.replace}
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

(fn hl-ify [hl]
  "escape highlight group for status line"
  (.. "%#" hl "#"))

(fn fmt-mode [mode-short]
  "format mode for status line"
  (let [hl-default hl.normal
        from-table (. modes-printnames mode-short)]
    (match from-table
      ;; name and hl group -> use all
      {:name name :hl hl!} (.. (hl-ify hl!) " " name)
      ;; just name -> default hl group
      {:name name} (.. (hl-ify hl-default) " " name)
      ;; otherwise -> default hl group and raw mode name
      _ (.. (hl-ify hl-default) " " mode-short))))

(fn get-mode []
  "get current mode from nvim and format for status line"
  (local m (. (vim.api.nvim_get_mode) :mode))
  (fmt-mode m))

(fn fmt-lsp [clients]
  "format attached lsp clients for status line"
  (if 
    ;; no clients -> empty string
    (or (= clients nil)
        (= (length clients) 0))
    ""
    ;; exactly one client -> print its name
    (= (length clients) 1)
    (. clients 1 :name)
    ;; less or equal than three clients -> comma separated names
    (<= (length clients) 3)
    (let [client-names (icollect [_ cl (ipairs clients)] cl.name)]
      (table.concat client-names ","))
    ;; more than three clients -> just print the number of clients
    (length clients)))

(fn get-lsp []
  "get currently attached lsp clients for status line"
  (local clients (vim.lsp.get_active_clients))
  (fmt-lsp clients))

(fn fmt-segments [segments]
  "format segments in the status line"
  (icollect [_ segment (ipairs segments)]
    (let [mapped (icollect [_ elem (ipairs segment)]
      (match elem
        {: s :hl hl!} (.. (hl-ify hl!) s)
        {: s} s))]
      (table.concat mapped " "))))

(fn statusline []
  "string for current statusline"
  (let [;; Left side: vim mode, filepath, and LSP outline.
        left (let [mode {:s (get-mode)}
                   path {:s " %f" :hl hl.main}
                   gps (when (gps-available?)
                         {:s (.. " " (gps-location))
                          :hl hl.alt})]
               [mode path gps])

        ;; Separator in the middle, pushing left and rigth side to each end.
        sep [{:s "%=" :hl hl.main}]

        ;; Right side: LSP clients and file specifics.
        right (let [hl-set {:s "" :hl hl.alt}
                    lsp (get-lsp)
                    lsp-clients {:s (when (not= lsp "")
                                      (.. "lsp:" lsp))}
                    pos {:s "pos:[%l:%c:%p%%]"}
                    ft {:s (.. "ft:" vim.bo.filetype)}]
                [hl-set lsp-clients pos ft])]

    (table.concat (fmt-segments [left sep right]) " ")))

{: statusline}
