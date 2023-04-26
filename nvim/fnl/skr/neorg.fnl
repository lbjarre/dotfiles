(fn setup []
  (let [neorg (require :neorg)
        ws :notes ;; Default workspace
        load {;; Default modules.
              :core.defaults {}
              ;; Make it pretty!
              :core.concealer {}
              ;; Manages workspace directories.
              :core.dirman {:config {:default_workspace ws
                                     :workspaces {ws "~/notes/neorg"}}}
              ;; Cmp integration.
              :core.completion {:config {:engine :nvim-cmp}}
              ;; Set the journal to use the default workspace.
              :core.journal {:config {:workspace ws}}
              ;; Presenter mode.
              :core.presenter {:config {:zen_mode :truezen}}}]
    (neorg.setup {: load})))

{: setup}
