local curl = require('plenary.curl')
local Job = require('plenary.job')

local gql = {}

local function create_split()
  vim.cmd('vsplit')
  local win = vim.api.nvim_get_current_win()
  local buf = vim.api.nvim_create_buf(true, true)
  vim.api.nvim_win_set_buf(win, buf)
  vim.cmd('set ft=graphql')
  return buf
end

local delimiters = {
  query    = '# ---query---',
  response = '# ---response---',
}

local function split(str, sep)
   local result = {}
   local regex = ("([^%s]+)"):format(sep)
   for each in str:gmatch(regex) do
      table.insert(result, each)
   end
   return result
end

function gql.start()
  local buf = create_split()

  vim.api.nvim_buf_set_lines(buf, 0, -1, false, {
    delimiters.query,
    '',
    delimiters.response,
    '',
  })
end

local function parse_buf(bufnr)
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  if #lines == 0 then
    error('empty buffer')
  end

  local idx_delim_query
  local idx_delim_resp
  for idx, line in ipairs(lines) do
    if line == delimiters.query then
      idx_delim_query = idx
    elseif line == delimiters.response then
      idx_delim_resp = idx
    end
  end

  if idx_delim_query == nil or idx_delim_resp == nil or idx_delim_query ~= 1 then
    error('malformed buffer')
  end

  local query = {}
  local resp = {}
  table.move(lines, idx_delim_query+1, idx_delim_resp-1, 1, query)
  table.move(lines, idx_delim_resp+1, -1, 1, resp)

  return {
    query = table.concat(query, '\n'),
    resp = table.concat(resp, '\n'),
  }
end

local function write_buf(bufnr, state)
  local lines = { delimiters.query }
  for _, qline in ipairs(split(state.query, '\n')) do
    table.insert(lines, qline)
  end
  table.insert(lines, delimiters.response)
  table.insert(lines, state.resp)

  vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
end

local function send_query(query)
  -- get nc token
  local token = Job:new({
    command = '/bin/sh',
    args = { '-c', [[ jq -r '.id_token' < ~/.nclogin/prod-creds.json ]] },
    enable_recording = true,
  }):sync()[1]

  -- send request
  local resp = curl.post({
    url  = 'https://api.northvolt.com/graphql',
    body = vim.json.encode({ query = query }),
    raw  = {
      '--header', string.format('Authorization: Bearer %s', token),
      '--header', 'Content-Type: application/json; charset=utf-8',
      '--header', 'Accept: application/json; charset=utf-8',
    }
  })

  return resp
end

function gql.post()
  local buf = vim.api.nvim_get_current_buf()
  local state = parse_buf(buf)
  local resp = send_query(state.query)
  write_buf(buf, {
    query = state.query,
    resp = resp.body,
  })
end

return gql
