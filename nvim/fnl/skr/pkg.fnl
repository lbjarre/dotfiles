(fn tset! [table key value]
  "Set a value in a table.

  Like `tset`, but also returns the table."
  (do
    (tset table key value)
    table))

(lambda pkg [name ?options]
  "Create a mixed sequence/key-value table for lazy packages."
  (-> ?options
      (or {})
      (tset! 1 name)))

(lambda setup [pkg-name ?setup-fn]
  "Create a setup function.

  Returns a new function that imports pkg-name and calls the setup function
  from that import."
  (fn []
    ((-> pkg-name
         (require)
         (. (or ?setup-fn :setup))))))

[;; Fennel transpilation.
 ;; This is already bootstrapped, but keeping it here will also update it with
 ;; the rest of these packages.
 (pkg :udayvir-singh/tangerine.nvim)
 ;; LSP stuff.
 (pkg :neovim/nvim-lspconfig {:config (setup :skr.lsp)})
 ;; TODO: this package is deprecated: I just use this for inlay hints now, but
 ;; that is not even working that well so should figure our how to do it better.
 (pkg :nvim-lua/lsp_extensions.nvim)
 ;; Wrap lua functions or other commands into LSP client commands.
 (pkg :jose-elias-alvarez/null-ls.nvim)
 ;; Quickfix list ~ish viewer for diagnostics.
 (pkg :folke/trouble.nvim)
 ;; Statusline widget showing code location (class/func/module etc).
 (pkg :SmiteshP/nvim-navic {:dependencies [:neovim/nvim-lspconfig]})
 ;; Wrapper around builtin terminal with easy toggling.
 (pkg :akinsho/toggleterm.nvim {:config (setup :skr.toggleterm)})
 ;; Automatic buffer resizing when new buffers are added/removed in a window,
 ;; e.g. toggling the terminal.
 (pkg :kwkarlwang/bufresize.nvim {:config (setup :bufresize)})
 (pkg :mrjones2014/smart-splits.nvim {:config (setup :skr.smart-splits)})
 ;; Completions.
 (pkg :hrsh7th/nvim-cmp {:dependencies [:hrsh7th/cmp-buffer
                                        :hrsh7th/cmp-path
                                        :hrsh7th/cmp-nvim-lsp
                                        :hrsh7th/cmp-cmdline
                                        :saadparwaiz1/cmp_luasnip]
                         :config (setup :skr.cmp)})
 ;; Snippet engine.
 (pkg :L3MON4D3/LuaSnip {;; We use some treesitter queries in the init scripts,
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
 ;; Debugging with DAP. Still not explored a lot here.
 (pkg :mfussenegger/nvim-dap {:config #(require :skr.dap)})
 (pkg :rcarriga/nvim-dap-ui)
 ;; Telescope, interactive fuzzy-finder.
 (pkg :nvim-telescope/telescope.nvim
      {:dependencies [:nvim-lua/popup.nvim :nvim-lua/plenary.nvim]
       :config (setup :skr.telescope)})
 ;; Native extension written in C that should be faster. Don't even know if I'm
 ;; using this though?
 (pkg :nvim-telescope/telescope-fzy-native.nvim
      {:dependencies [:nvim-telescope/telescope.nvim]})
 ;; Extra db of symbols (like emojis).
 (pkg :nvim-telescope/telescope-symbols.nvim
      {:dependencies [:nvim-telescope/telescope.nvim]})
 (pkg :nvim-telescope/telescope-ui-select.nvim
      {:dependencies [:nvim-telescope/telescope.nvim]})
 ;; Lush, nice colorscheme package with an interactive mode.
 (pkg :rktjmp/lush.nvim)
 ;; Icons via nerdfonts.
 (pkg :kyazdani42/nvim-web-devicons {:config (setup :nvim-web-devicons)})
 ;; Noice, substantial nvim UI plugin
 (pkg :rcarriga/nvim-notify
      {:config #(let [notify (require :notify)]
                  (notify.setup {:background_color "#000000"}))})
 (pkg :folke/noice.nvim
      {:dependencies [:MunifTanjim/nui.nvim :rcarriga/nvim-notify]
       :config #(let [noice (require :noice)]
                  (noice.setup {:lsp {:override {:vim.lsp.util.convert_input_to_markdown_lines true
                                                 :vim.lsp.util.stylize_markdown true
                                                 :cmp.entry.get_documentation true}}}))})
 ;; ZenMode, declutter and focus on window / selection.
 (pkg :Pocco81/true-zen.nvim {:config (setup :true-zen)})
 ;; Language-aware comment plugin
 (pkg :numToStr/Comment.nvim {:config (setup :Comment)})
 ;; Lots of good integrations with git, like showing diffs in the numberline
 ;; and being able to see blames inline etc
 (pkg :lewis6991/gitsigns.nvim
      {:dependencies [:nvim-lua/plenary.nvim] :config (setup :gitsigns)})
 ;; UI for viewing git diffs.
 (pkg :sindrets/diffview.nvim
      {:dependencies [:nvim-lua/plenary.nvim] :config (setup :diffview)})
 ;; Integrated Github UI and API, e.g. checkout and review PR in neovim.
 (pkg :pwntester/octo.nvim {:config (setup :octo)})
 ;; Plugin for displaying tree structures, including a file browser.
 (pkg :nvim-neo-tree/neo-tree.nvim
      {:branch :v2.x
       :dependencies [:nvim-lua/plenary.nvim
                      :kyazdani42/nvim-web-devicons
                      :MunifTanjim/nui.nvim]
       :config (setup :skr.neo-tree)})
 ;; Hydra, plugin for submodes with UI for keybinds.
 (pkg :anuvyklack/hydra.nvim {:config (setup :skr.hydra)})
 ;; Telekasten notetaking. Not really using it atm...
 (pkg :renerocksai/telekasten.nvim)
 ;; Revamped orgmode for nvim. Testing it out!
 (pkg :nvim-neorg/neorg
      {:build ":Neorg sync-parsers"
       :config (setup :skr.neorg)
       :dependencies [:nvim-lua/plenary.nvim]})
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
 ;; Church of Tpope.
 (pkg :tpope/vim-surround)
 ;; Parinfer, make lisp life easier.
 (pkg :eraserhd/parinfer-rust
      {:build "cargo build --release" :ft [:fennel :clojure :racket :janet]})
 ;; Lang specific plugins.
 (pkg :cespare/vim-toml {:branch :main})
 (pkg :b4b4r07/vim-hcl)
 (pkg :towolf/vim-helm)
 ;; Plugin for running cellular automata based on buffer content. Very silly.
 (pkg :eandrju/cellular-automaton.nvim)]
