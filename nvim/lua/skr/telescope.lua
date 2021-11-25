local telescope = require('telescope')
local builtin = require('telescope.builtin')
local themes = require('telescope.themes')
local previewers = require('telescope.previewers')

local M = {}

M.setup = function()
  telescope.setup {
    defaults = {
      vimgrep_arguments = {
        'rg',
        '--no-heading',
        '--with-filename',
        '--line-number',
        '--column',
        '--smart-case',
        '--hidden',
      },
      set_env = { ['COLORTERM'] = 'truecolor' },
      file_previewer = previewers.vim_buffer_cat.new,
      grep_previewer = previewers.vim_buffer_vimgrep.new,
      qflist_previewer = previewers.vim_buffer_qflist.new,
    }
  }
end

M.files = function()
  opts = {
    hidden = true,
  }
  local ok = pcall(builtin.git_files, opts)
  if not ok then
    builtin.find_files(opts)
  end
end

M.search_buf = function()
  builtin.current_buffer_fuzzy_find(themes.get_ivy {
    layout_config = { prompt_position = 'top' },
    sorting_strategy = 'ascending',
  })
end

M.grep_string = function()
  builtin.grep_string {
    search = vim.fn.input("search: "),
  }
end

M.lsp_workspace_symbols = function()
  builtin.lsp_workspace_symbols {
    query = vim.fn.input("search: "),
  }
end

M.lsp_code_actions = function()
  builtin.lsp_code_actions(themes.get_dropdown())
end

M.lsp_def = function()
  builtin.lsp_definitions()
end

M.lsp_ref = function()
  builtin.lsp_references()
end

M.lsp_impl = function()
  builtin.lsp_implementations()
end

M.lsp_ws_diagnostics = function()
  builtin.lsp_workspace_diagnostics()
end

M.lsp_doc_symbols = function()
  builtin.lsp_document_symbols()
end

return M
