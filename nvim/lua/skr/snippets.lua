local luasnip = require('luasnip')
local tsutil = require('nvim-treesitter.ts_utils')
local tslocals = require('nvim-treesitter.locals')

local c = luasnip.c -- choice node
local f = luasnip.f -- function node
local i = luasnip.i -- insert node
local t = luasnip.t -- text node
local d = luasnip.d -- dynamic node

local handlers = {
  ["parameter_list"] = function(node, info)
    local result = {}
    local count = node:named_child_count()
    for i = 0, count - 1 do
      table.insert(result, transform(get_node_text))
    end
  end
}

vim.treesitter.set_query(
  "go",
  "luasnip-return",
  [[
  [
    (method_declaration result: (*) @id)
    (function_declaration result: (*) @id)
    (func_literal result: (*) @id)
  ]
  ]]
)

local go_return_type = function(info) 
  local cursor = tsutil.get_node_at_cursor()
  local scope = tslocals.get_scope_tree(cursor, 0)

  local func_node
  for _, v in ipairs(scope) do
    local t = v:type()
    if t == "function_declaration" or t == "method_declaration" or t == "func_literal" then
      func_node = v
      break
    end
  end

  local query = vim.treesitter.get_query("go", "luasnip-return")
  for id, node in query:iter_captures(func_node, 0) do
    if handlers[node:type()] then
      return handlers[node:type()](node, info)
    end
  end
end

local M = {}
M.setup = function() end
return M
