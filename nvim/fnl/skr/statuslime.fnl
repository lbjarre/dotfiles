(local hlgroup-normal "StatusModeNormal")
(local hlgroup-insert "StatusModeInsert")
(local hlgroup-visual "StatusModeVisual")
(local hlgroup-replace "StatusModeReplace")
(local hlgroup-main "StatusMain")
(local hlgroup-left "StatusLeft")

(let [set-hl (fn [name fg bg]
              (vim.cmd (..
                        "highlight " name
                        " ctermfg=" fg
                        " ctermbg=" bg)))]
    (set-hl hlgroup-normal 0 7)
    (set-hl hlgroup-insert 0 4)
    (set-hl hlgroup-visual 0 11)
    (set-hl hlgroup-replace 0 1)
    (set-hl hlgroup-main 0 15)
    (set-hl hlgroup-left 0 7))

;; mapping from short mode names to full names and optional highlight groups
(local modes-printnames
     ;; normal modes
    {:n   {:name "normal"             :hl hlgroup-normal}
     :no  {:name "n·operator pending" :hl hlgroup-normal}
     ;; visual modes
     :v   {:name "visual"             :hl hlgroup-visual}
     :V   {:name "v·line"             :hl hlgroup-visual}
     "" {:name "v·block"            :hl hlgroup-visual}
     ;; insert mode
     :i   {:name "insert"             :hl hlgroup-insert}
     ;; replace modes
     :R   {:name "replace"            :hl hlgroup-replace}
     :Rv  {:name "v·replace"          :hl hlgroup-replace}
     ;; rest of the modes
     ;; these are all taken from some other plugin, don't really know what they
     ;; all actually do
     :s   {:name "select"}
     :S   {:name "s·line"}
     "" {:name "s·block"}
     :c   {:name "command"}
     :cv  {:name "vim ex"}
     :ce  {:name "ex"}
     :r   {:name "prompt"}
     :rm  {:name "more"}
     :r?  {:name "confirm"}
     :!   {:name "shell"}
     :t   {:name "terminal"}})

(fn hl-ify [hl]
    "escape highlight group for status line printing"
    (.. "%#" hl "#"))

(fn get-mode []
    "read the current mode and output escaped string"
    (let [mode-raw (. (vim.api.nvim_get_mode) :mode)
          from-table (. modes-printnames mode-raw)
          hlgroup-default hlgroup-normal]
     (match from-table
        ;; name and hl group -> use all
        {:name name :hl hl} (.. (hl-ify hl) " " name " ")
        ;; just name -> default hl group
        {:name name}        (.. (hl-ify hlgroup-default) name " ")
        ;; otherwise -> default hl group and raw mode name
        _                   (.. (hl-ify hlgroup-default) mode-raw " "))))


(fn get-lsp []
    "get and stringify status for active lsp clients"
    (let [clients (vim.lsp.get_active_clients)]
     (if (or (= clients nil) (= (length clients) 0))
         ""
         (= (length clients) 1)
         (. clients 1 :name)
         (length clients))))

(fn statusline []
    "string for current statusline"
    (..
     ;; Left side
     ;;   mode
     " "
     (get-mode)
     (hl-ify hlgroup-main)
     ;;   current file
     " %f"
     ;; Separator
     "%= "
     ;; Right side
     (hl-ify hlgroup-left)
     ;;   lsp info
     (get-lsp)
     ;;   line and col
     " %l,%c"
     ;;   percent way through file
     " %p%% "
     ;;   filetype
     vim.bo.filetype
     " "))

{: statusline}
