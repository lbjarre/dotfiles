(local {:get_location navic-location
        :is_available navic-available?} (require :nvim-navic))

(local {:api {:nvim_get_mode api/get-mode
              :nvim_buf_get_option api/buf-get-opt}
        :lsp {:get_active_clients lsp/get-active-clients}} vim)

(fn map [xs func]
  (icollect [_ x (ipairs xs)]
    (func x)))

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

(fn fmt-mode [mode-output]
  "Format vim mode for status line.

  Takes input as received from the `nvim_get_mode` API."
  (let [{: mode} mode-output
        hl-default hl-normal]
    (-> mode-printname
        (. mode)
        (match
          {: name : hl} {: name : hl}
          {: name}      {: name :hl hl-default}
          _             {:name mode :hl hl-default}))))

(fn fmt-lsp [clients]
  "format attached lsp clients for status line"
  (-?> clients
       (length)
       (match
         ;; no clients -> nil
         0 nil
         ;; less or equal than three clients -> comma separated names
         (where n (<= n 3)) (-> clients
                                (map #$1.name)
                                (table.concat ","))
         ;; more than three clients -> just print the number of clients
         _ (tostring n))))

(fn with-prefix [x prefix]
  "Returns '${prefix}${x}' if x is not nil or empty, else ''."
  (if (= nil x) ""
      (= "" x) ""
      (.. prefix x)))

(fn statusline []
  "Format statusline string.

  Can be used with the `vim.opt.statusline` option with `!luaeval`:
    !luaeval(\"require('skr.statuslime').statusline()\")"
  (let [;; Vim mode.
        {:name mode-name :hl mode-hl} (-> (api/get-mode)
                                          (fmt-mode))

        ;; LSP outline, when availabe.
        navic (-> (navic-available?)
                  (if (navic-location) ""))

        ;; Separator in the middle, pushing left and right side to each end.
        sep "%="

        ;; Active LSP clients, if any.
        lsp (-> (lsp/get-active-clients)
                (fmt-lsp)
                (with-prefix "lsp:"))

        ;; File position.
        pos "pos:[%l:%c:%p%%]"

        ;; File type.
        ft (-> (api/buf-get-opt 0 :filetype)
               (with-prefix "ft:"))

        ;; All together now!
        segments [(hl-esc mode-hl)
                  mode-name
                  (hl-esc hl-main)
                  navic
                  sep
                  (hl-esc hl-alt)
                  lsp
                  pos
                  ft
                  ""]] ;; empty segment in the end to add padding.

    (-> segments
        (table.concat " "))))

{: statusline}
