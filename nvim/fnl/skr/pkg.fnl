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
 (pkg :akinsho/toggleterm.nvim)
 ;; Completions.
 (pkg :hrsh7th/nvim-cmp {:dependencies [:hrsh7th/vim-vsnip
                                        :hrsh7th/cmp-buffer
                                        :hrsh7th/cmp-path
                                        :hrsh7th/cmp-nvim-lsp
                                        :saadparwaiz1/cmp_luasnip]
                         :config (setup :skr.cmp)})
 ;; Snippet engine.
 (pkg :L3MON4D3/LuaSnip)
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
 (pkg :nvim-telescope/telescope-fzy-native.nvim)
 ;; Lush, nice colorscheme package with an interactive mode.
 (pkg :rktjmp/lush.nvim)
 ;; Icons via nerdfonts.
 (pkg :kyazdani42/nvim-web-devicons {:config (setup :nvim-web-devicons)})
 ;; Fancier UI elements, like select and input boxes.
 (pkg :stevearc/dressing.nvim
      {:config (fn []
                 (local dressing (require :dressing))
                 (do
                   (dressing.setup)
                   (dressing.patch)))})
 ;; Progress indicator for async tasks.
 (pkg :j-hui/fidget.nvim {:config (setup :fidget)})
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
                      :MunifTanjim/nui.nvim]})
 ;; Hydra, plugin for submodes with UI for keybinds.
 (pkg :anuvyklack/hydra.nvim)
 ;; Telekasten notetaking. Not really using it atm...
 (pkg :renerocksai/telekasten.nvim)
 ;; Revamped orgmode for nvim. Testing it out!
 (pkg :nvim-neorg/neorg
      {:build ":Neorg sync-parsers"
       :config (setup :skr.neorg)
       :dependencies [:nvim-lua/plenary.nvim]})
 ;; UI for showing keybinds
 (pkg :folke/which-key.nvim)
 ;; Start screen
 (pkg :mhinz/vim-startify)
 ;; ASCII box diagram drawing
 (pkg :jbyuki/venn.nvim)
 ;; Render markdown with hot code reloading
 (pkg :iamcco/markdown-preview.nvim
      {:build "cd app && npm install"
       :setup (fn []
                (set vim.g.mkdp_filetypes [:markdown]))
       :ft [:markdown]})
 ;; Church of Tpope.
 (pkg :tpope/vim-surround)
 ;; Lang specific plugins.
 (pkg :cespare/vim-toml {:branch :main})
 (pkg :b4b4r07/vim-hcl)
 (pkg :towolf/vim-helm)
 ;; Plugin for running cellular automata based on buffer content. Very silly.
 (pkg :eandrju/cellular-automaton.nvim)]
