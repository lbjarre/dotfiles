(local hl
       {:normal "StatusModeNormal"
        :insert "StatusModeInsert"
        :visual "StatusModeVisual"
        :replace "StatusModeReplace"
        :main "StatusMain"
        :left "StatusLeft"})

(let [set-hl (fn [name fg bg]
              (vim.cmd (..
                        "highlight " name
                        " ctermfg=" fg
                        " ctermbg=" bg)))]
    (set-hl hl.normal 0 7)
    (set-hl hl.insert 0 4)
    (set-hl hl.visual 0 11)
    (set-hl hl.replace 0 1)
    (set-hl hl.main 0 15)
    (set-hl hl.left 0 7))

;; mapping from short mode names to full names and optional highlight groups
(local modes-printnames
     ;; normal modes
    {:n   {:name "normal"             :hl hl.normal}
     :no  {:name "n·operator pending" :hl hl.normal}
     ;; visual modes
     :v   {:name "visual"             :hl hl.visual}
     :V   {:name "v·line"             :hl hl.visual}
     "" {:name "v·block"            :hl hl.visual}
     ;; insert mode
     :i   {:name "insert"             :hl hl.insert}
     ;; replace modes
     :R   {:name "replace"            :hl hl.replace}
     :Rv  {:name "v·replace"          :hl hl.replace}
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

(fn fmt-mode [mode-short]
    (let [hl-default hl.normal
          from-table (. modes-printnames mode-short)]
     (match from-table
        ;; name and hl group -> use all
        {:name name :hl hl!} (.. (hl-ify hl!) " " name " ")
        ;; just name -> default hl group
        {:name name} (.. (hl-ify hl-default) " " name " ")
        ;; otherwise -> default hl group and raw mode name
        _ (.. (hl-ify hl-default) " " mode-short " "))))

(fn get-mode []
    (let [m (. (vim.api.nvim_get_mode) :mode)]
     (fmt-mode m)))

(fn fmt-lsp [clients]
    (if (or (= clients nil)
            (= (length clients) 0))
        ""
        (= (length clients) 1)
        (. clients 1 :name)
        (length clients)))

(fn get-lsp []
    (let [clients (vim.lsp.get_active_clients)]
     (fmt-lsp clients)))

(fn statusline []
    "string for current statusline"
    (table.concat
      ;; Left side
     [(get-mode) (hl-ify hl.main) "%f"
      ;; Separator
      "%="
      ;; Right side
      (hl-ify hl.left) (get-lsp) "%l,%c" "%p%%" vim.bo.filetype ""]
     " "))

{: statusline}
