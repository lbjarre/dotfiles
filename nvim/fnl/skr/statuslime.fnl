(local {:get_location navic-location :is_available navic-available?}
       (require :nvim-navic))

(local {: nil?} (require :skr.std))

(fn map [xs func]
  (icollect [_ x (ipairs xs)]
    (func x)))

;; highlight group names
;; Main and Alt hightlight groups
(local hl-main :StatusLine)
(local hl-alt :StatusLineAlt)
;; StatusLineMode$X for highlighting different modes
(local hl-normal :StatusLineModeNormal)
(local hl-insert :StatusLineModeInsert)
(local hl-visual :StatusLineModeVisual)
(local hl-replace :StatusLineModeReplace)

(fn hl-esc [hl]
  "escape highlight group for status line"
  (.. "%#" hl "#"))

;; mapping from short mode names to full names and optional highlight groups
(local mode-printname {;; normal modes
                       :n {:name :normal :hl hl-normal}
                       :no {:name "n·op·pending" :hl hl-normal}
                       ;; visual modes
                       :v {:name :visual :hl hl-visual}
                       :V {:name "v·line" :hl hl-visual}
                       "\022" {:name "v·block" :hl hl-visual}
                       ;; insert mode
                       :i {:name :insert :hl hl-insert}
                       ;; replace modes
                       :R {:name :replace :hl hl-replace}
                       :Rv {:name "v·replace" :hl hl-replace}
                       ;; rest of the modes
                       ;; these are all taken from some other plugin, don't really know what they
                       ;; all actually do
                       :s {:name :select}
                       :S {:name "s·line"}
                       "\019" {:name "s·block"}
                       :c {:name :command}
                       :cv {:name "vim·ex"}
                       :ce {:name :ex}
                       :r {:name :prompt}
                       :rm {:name :more}
                       :r? {:name :confirm}
                       :! {:name :shell}
                       :t {:name :terminal}})

(fn fmt-mode [mode-output]
  "Format vim mode for status line.

  Takes input as received from the `nvim_get_mode` API."
  (let [{: mode} mode-output
        printname (. mode-printname mode)
        hl-default hl-normal]
    (case printname
      {: name : hl} {: name : hl}
      {: name} {: name :hl hl-default}
      _ {:name mode :hl hl-default})))

(fn fmt-lsp [clients]
  "format attached lsp clients for status line"
  (-?> clients
       (length)
       (match ;; no clients -> nil
         0
         nil
         ;; less or equal than three clients -> comma separated names
         (where n (<= n 3))
         (-> clients
             (map #$1.name)
             (table.concat ","))
         ;; more than three clients -> just print the number of clients
         n
         (tostring n))))

(fn with-prefix [x prefix]
  "Returns '${prefix}${x}' if x is not nil or empty, else ''."
  (if (nil? x) ""
      (= "" x) ""
      (.. prefix x)))

(fn mode []
  (fmt-mode (vim.api.nvim_get_mode)))

(fn navic []
  (if (navic-available?)
      (navic-location) ""))

(fn lsp []
  (-> (vim.lsp.get_clients)
      (fmt-lsp)
      (with-prefix "lsp:")))

(fn pos []
  "pos:[%l:%c:%p%%]")

(fn ft []
  (-> (vim.api.nvim_get_option_value :filetype {:buf 0})
      (with-prefix "ft:")))

(fn statusline []
  "Format statusline string.

  Can be used with the `vim.opt.statusline` option with `!luaeval`:
    !luaeval(\"require('skr.statuslime').statusline()\")"
  (let [mode (mode)
        segments [(hl-esc mode.hl)
                  mode.name
                  (hl-esc hl-main)
                  (navic)
                  "%="
                  (hl-esc hl-alt)
                  (lsp)
                  (pos)
                  (ft)
                  ""]]
    (table.concat segments " ")))

{: statusline}
