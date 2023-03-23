(fn setup []
  (let [neorg (require :neorg)
        ws :notes ;; Default workspace
        load {;; Default modules.
              :core.defaults {}
              ;; Make it pretty!
              :core.norg.concealer {}
              ;; Manages workspace directories.
              :core.norg.dirman {:config {:default_workspace ws
                                          :workspaces {ws "~/notes/neorg"}}}
              ;; Cmp integration.
              :core.norg.completion {:config {:engine :nvim-cmp}}
              ;; Set the journal to use the default workspace.
              :core.norg.journal {:config {:workspace ws}}
              ;; Presenter mode.
              :core.presenter {:config {:zen_mode :truezen}}}]
    (neorg.setup {: load})))

{: setup}
