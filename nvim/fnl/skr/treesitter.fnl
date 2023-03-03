(fn setup []
  (let [{: setup} (require :nvim-treesitter.configs)]
    (setup {:autotag {:enable true}
            :playground {:enable true}
            :indent {:enable true}
            :highlight {:enable true}
            :textobjects {:select {:enable true
                                   :lookahead true
                                   :keymaps {:af "@function.outer"
                                             :if "@function.inner"}}}})))

{: setup}
