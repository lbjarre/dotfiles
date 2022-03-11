local luasnip = require('luasnip')
local tsutil = require('nvim-treesitter.ts_utils')
local tslocals = require('nvim-treesitter.locals')

local c = luasnip.c -- choice node
local f = luasnip.f -- function node
local i = luasnip.i -- insert node
local t = luasnip.t -- text node
local d = luasnip.d -- dynamic node

local setup_ts_queries = function()
  vim.treesitter.set_query(
    "go",
    "luasnip-return",
    [[
    [
      (method_declaration result: (_) @ret)
      (function_declaration result: (_) @ret)
      (func_literal result: (_) @ret)
    ]
    ]]
  )
end


local go_type_nil_value = function(text, info)
  if text == "int" then
    return t("0")
  elseif text == "error" then
    return t("err")
  elseif text == "bool" then
    return t("false")
  elseif text == "string" then
    return t([[""]])
  elseif string.find(text, "*", 1, true) then
    return t("nil")
  end
  return t(text)
end

local go_return_values = function(args)
  luasnip.sn(nil, go_return_type({
    index = 0,
    err_name = args[1][1],
    func_name = args[2][1],
  }))
end

local handlers = {
  ["parameter_list"] = function(node, info)
    local result = {}
    local count = node:named_child_count()
    for idx = 0, count - 1 do
      table.insert(result, go_type_nil_value(vim.treesitter.get_node_text, info))
      if idx ~= count - 1 then
        table.insert(result, t { "," })
      end
    end
  end
}

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
  for _, node in query:iter_captures(func_node, 0) do
    if handlers[node:type()] then
      return handlers[node:type()](node, info)
    end
  end
end

return {
  setup = function()
    setup_ts_queries()
  end,
}
