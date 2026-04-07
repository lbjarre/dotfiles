(local ts (require :nvim-treesitter))

;; Treesitter grammars that we check and ensure are installed at startup.
(local ensure-installed [:nix
                         :go
                         :gomod
                         :gosum
                         :gotmpl
                         :python
                         :bash
                         :zsh
                         :lua
                         :fennel
                         :vim
                         :c
                         :cpp
                         :cmake
                         :make
                         :proto
                         :textproto
                         :sql
                         :zig
                         :rust
                         :erlang
                         :haskell
                         :ocaml
                         :ocaml_interface
                         :janet_simple
                         :prolog
                         :javascript
                         :typescript
                         :css
                         :html
                         :html_tags
                         :svelte
                         :astro
                         :yaml
                         :json
                         :json5
                         :hjson
                         :toml
                         :jsonnet
                         :kdl
                         :starlark
                         :dockerfile
                         :terraform
                         :caddy
                         :promql])

(fn not-installed []
  "Get the delta between ensure-installed and installed grammars, i.e. which ones to install."
  (local installed (ts.get_installed))
  (local to-install [])
  (each [_ lang (ipairs ensure-installed)]
    (if (not (vim.list_contains installed lang))
        (table.insert to-install lang)))
  to-install)

(fn installed? [ft]
  ""
  (let [installed-langs (ts.get_installed)
        lang (vim.treesitter.language.get_lang ft)]
    (vim.list_contains installed-langs lang)))

(fn callback [args]
  "Autocmd callback to start treesitter for installed languages."
  (if (installed? args.match) (vim.treesitter.start args.buf)))

(fn setup []
  (ts.setup {})
  ;; Install grammars not yet installed.
  (ts.install (not-installed))
  ;; Create an autocmd to start treesitter in buffers with installed grammars.
  (local group (vim.api.nvim_create_augroup :treesitter {:clear true}))
  (vim.api.nvim_create_autocmd :FileType {: group : callback}))

{: setup}
