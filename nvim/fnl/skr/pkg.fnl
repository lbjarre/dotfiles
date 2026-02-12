(lambda pkg [name ?options]
  "Create a mixed sequence/key-value table for lazy packages.

  Lazy uses luas ambiguous tables for both sequence access and key-values:

  ```lua
  { 'author/pkg-name', config = config_function, dependencies = { 'author/dep' } }
  ```

  This will set the package name as the first value using the table as a
  sequential array (index 1, because of course), and the rest as key-values
  using it as a map. In lua both of these share the same surrounding brackets,
  but in fennel they are different (`[]` vs `{}`). This function creates a
  table with the expected form: the above example can be created using:

  ```fennel
  (pkg :author/pkg-name {:config config_function
                         :dependencies [:author/dep]})
  ```"
  (let [table (or ?options {})]
    (tset table 1 name)
    table))

(lambda setup [pkg-name ?opts]
  "Create a setup function.

  Returns a new function that imports pkg-name and calls the setup function
  from that import."
  #(let [{: setup} (require pkg-name)]
     (setup ?opts)))

[;; Fennel transpilation.
 ;; This is already bootstrapped, but keeping it here will also update it with
 ;; the rest of these packages.
 (pkg :udayvir-singh/tangerine.nvim)
 ;; LSP stuff.
 (pkg :neovim/nvim-lspconfig {:config (setup :skr.lsp)})
 ;; Formatter plugin.
 (pkg :stevearc/conform.nvim {:config (setup :skr.conform)})
 ;; Quickfix list ~ish viewer for diagnostics.
 (pkg :folke/trouble.nvim {:cmd :Trouble})
 ;; Statusline widget showing code location (class/func/module etc).
 (pkg :SmiteshP/nvim-navic {:dependencies [:neovim/nvim-lspconfig]})
 ;; Automatic buffer resizing when new buffers are added/removed in a window,
 ;; e.g. toggling the terminal.
 (pkg :kwkarlwang/bufresize.nvim {:config (setup :bufresize)})
 (pkg :mrjones2014/smart-splits.nvim {:config (setup :skr.smart-splits)})
 ;; Wrapper around builtin terminal with easy toggling.
 (pkg :akinsho/toggleterm.nvim {:config (setup :skr.toggleterm)})
 ;; Completions.
 (pkg :hrsh7th/nvim-cmp {:dependencies [:hrsh7th/cmp-buffer
                                        :hrsh7th/cmp-path
                                        :hrsh7th/cmp-nvim-lsp
                                        :hrsh7th/cmp-nvim-lsp-signature-help
                                        :hrsh7th/cmp-cmdline
                                        :saadparwaiz1/cmp_luasnip]
                         :config (setup :skr.cmp)})
 ;; Snippet engine.
 (pkg :L3MON4D3/LuaSnip {:version :v2.*
                         ;; We use some treesitter queries in the init scripts,
                         ;; so need to declare it as a dependency.
                         :dependencies [:nvim-treesitter/nvim-treesitter]
                         :config (setup :skr.fnlsnip)})
 ;; Treesitter.
 (pkg :nvim-treesitter/nvim-treesitter
      {:build ":TSUpdate"
       :dependencies [:windwp/nvim-ts-autotag
                      :nvim-treesitter/playground
                      :nvim-treesitter/nvim-treesitter-textobjects
                      :JoosepAlviste/nvim-ts-context-commentstring]
       :config (setup :skr.treesitter)})
 ;; SSR: Structural search & replace. Pretty cool thing to search/replace with
 ;; treesitter queries, not entirely sure how useful it is yet though.
 (pkg :cshuaimin/ssr.nvim {:config (setup :ssr)})
 ;; leap.nvim: quick jumping to any 2-character pattern in a buffer.
 ;; Trying it out for now.
 (pkg "https://codeberg.org/andyg/leap.nvim"
      {:dependencies [:tpope/vim-repeat]
       :config #(let [leap (require :leap)]
                  (vim.keymap.set [:n :x :o] :s "<Plug>(leap)")
                  (vim.keymap.set :n :S "<Plug>(leap-from-window"))})
 ;; iedit.nvim: multiple cursor edit kind of thing.
 (pkg :altermo/iedit.nvim)
 ;; undotree: visualize buffer edits.
 (pkg :mbbill/undotree)
 ;; Debugging with DAP. Still not explored a lot here.
 (pkg :mfussenegger/nvim-dap)
 (pkg :rcarriga/nvim-dap-ui
      {:dependencies [:nvim-neotest/nvim-nio] :config (setup :dapui)})
 (pkg :leoluz/nvim-dap-go {:config (setup :dap-go)})
 ;; Telescope, interactive fuzzy-finder.
 (pkg :nvim-telescope/telescope.nvim
      {:dependencies [:nvim-lua/popup.nvim :nvim-lua/plenary.nvim]
       :config (setup :skr.telescope)})
 ;; Extension for reading files from Jujutsu.
 (pkg :zschreur/telescope-jj.nvim
      {:dependencies [:nvim-telescope/telescope.nvim]})
 ;; Native extension written in C that should be faster. Don't even know if I'm
 ;; using this though?
 (pkg :nvim-telescope/telescope-fzy-native.nvim
      {:dependencies [:nvim-telescope/telescope.nvim]})
 ;; Extra db of symbols (like emojis).
 (pkg :nvim-telescope/telescope-symbols.nvim
      {:dependencies [:nvim-telescope/telescope.nvim]})
 (pkg :nvim-telescope/telescope-ui-select.nvim
      {:dependencies [:nvim-telescope/telescope.nvim]})
 ;; LLM integrations
 ;; Opencode, interactive CLI tool for software engineering tasks.
 (pkg :NickvanDyke/opencode.nvim
      {:config (fn []
                 (let [opencode (require :opencode)]
                   ;; Configure opencode to use terminal provider
                   (set vim.g.opencode_opts {:provider {:enabled :terminal}})
                   (set vim.o.autoread true)
                   ;; Keymap to execute opencode action
                   (vim.keymap.set [:n :x] :<leader>lx #(opencode.select)
                                   {:desc "Execute opencode action"})
                   (vim.keymap.set [:n :x] :<leader>ll #(opencode.toggle)
                                   {:desc "Toggle opencode"})))})
 ;; Lush, nice colorscheme package with an interactive mode.
 (pkg :rktjmp/lush.nvim)
 ;; Icons via nerdfonts.
 (pkg :kyazdani42/nvim-web-devicons {:config (setup :nvim-web-devicons)})
 ;; Noice, substantial nvim UI plugin
 (pkg :rcarriga/nvim-notify
      {:config #(let [notify (require :notify)]
                  (notify.setup {:background_colour "#000000"
                                 :render :compact
                                 :timeout 3}))})
 (pkg :folke/noice.nvim
      {:dependencies [:MunifTanjim/nui.nvim :rcarriga/nvim-notify]
       :config #(let [noice (require :noice)]
                  (noice.setup {:lsp {:override {:vim.lsp.util.convert_input_to_markdown_lines true
                                                 :vim.lsp.util.stylize_markdown true
                                                 :cmp.entry.get_documentation true}}}))})
 ;; ZenMode, declutter and focus on window / selection.
 (pkg :Pocco81/true-zen.nvim {:config (setup :true-zen)})
 ; ;; Language-aware comment plugin
 ; (pkg :numToStr/Comment.nvim {:config (setup :Comment)})
 ;; Lots of good integrations with git, like showing diffs in the numberline
 ;; and being able to see blames inline etc
 (pkg :lewis6991/gitsigns.nvim
      {:dependencies [:nvim-lua/plenary.nvim] :config (setup :gitsigns)})
 ;; UI for viewing git diffs.
 (pkg :sindrets/diffview.nvim
      {:dependencies [:nvim-lua/plenary.nvim] :config (setup :diffview)})
 ;; Plugin for displaying tree structures, including a file browser.
 (pkg :nvim-neo-tree/neo-tree.nvim
      {:branch :v3.x
       :dependencies [:nvim-lua/plenary.nvim
                      :kyazdani42/nvim-web-devicons
                      :MunifTanjim/nui.nvim]
       :config (setup :skr.neo-tree)})
 ;; File explorer.
 (pkg :stevearc/oil.nvim
      {:dependencies [:nvim-tree/nvim-web-devicons]
       :lazy false
       :opts {:columns [:icon :permissions :size :mtime]
              :watch_for_changes true
              :view_options {:show_hidden true}}})
 ;; overseer.nvim: task runner.
 ;; TODO: looks very promising, but lots of things to configure to make it
 ;; super smooth. Would like to have something where you can run a go-test on
 ;; file changes and quickly get feedback.
 (pkg :stevearc/overseer.nvim
      {:enabled false
       :config #(let [overseer (require :overseer)]
                  (overseer.setup))})
 ;; UI for showing keybinds
 (pkg :folke/which-key.nvim {:config (setup :which-key)})
 ;; Dashboard start screen
 (pkg :goolord/alpha-nvim {:config (setup :skr.alpha)})
 ;; ASCII box diagram drawing
 (pkg :jbyuki/venn.nvim)
 ;; Render markdown with hot code reloading
 (pkg :iamcco/markdown-preview.nvim
      {:build "cd app && npm install"
       :setup #(set vim.g.mkdp_filetypes [:markdown])
       :ft [:markdown]})
 (pkg :MeanderingProgrammer/render-markdown.nvim
      {:dependencies [:nvim-treesitter/nvim-treesitter
                      :nvim-tree/nvim-web-devicons]})
 ;; Church of Tpope.
 (pkg :tpope/vim-surround)
 ;; Parinfer, make lisp life easier.
 (pkg :gpanders/nvim-parinfer)
 ;; Lang specific plugins.
 (pkg :cespare/vim-toml {:branch :main :enabled false})
 (pkg :b4b4r07/vim-hcl {:enabled false})
 (pkg :towolf/vim-helm {:enabled false})
 ;; Now we are getting silly.
 ;; Plugin for running cellular automata based on buffer content.
 (pkg :eandrju/cellular-automaton.nvim {:enabled false})
 ;; Spawn ducks that roam the buffer.
 (pkg :tamton-aquib/duck.nvim
      {:enabled false
       :config #(let [duck (require :duck)]
                  (vim.keymap.set :n :<leader>dd #(duck.hatch))
                  (vim.keymap.set :n :<leader>dk #(duck.cook)))})
 ;; Sudoku, in nvim!
 (pkg :jim-fx/sudoku.nvim {:opts {}})]
