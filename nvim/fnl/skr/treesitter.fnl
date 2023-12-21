(fn setup []
  (let [ts-config (require :nvim-treesitter.configs)]
    (ts-config.setup {:autotag {:enable true}
                      :playground {:enable true}
                      :indent {:enable true}
                      :highlight {:enable true}
                      :textobjects {:select {:enable true
                                             :lookahead true
                                             :keymaps {:af "@function.outer"
                                                       :if "@function.inner"}}}})))

{: setup}

