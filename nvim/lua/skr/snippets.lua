local ls = require('luasnip')

local t = ls.text_node
local i = ls.insert_node
local c = ls.choice_node
local fmt = require('luasnip.extras.fmt').fmt

ls.snippets = {
  all = {
    ls.snippet(
      "todo",
      fmt(
        "{}",
        c(1, {
          t "TODO(lb): ",
          t "FIXME(lb): ",
          t "NOTE(lb): ",
        })
      )
    )
  },
  go = {
    ls.snippet("testtable", fmt(
    [[
func Test<>(t *testing.T) {
	testcases := []struct{
		name string
	}{
		{
			name: "<>",
		},
	}
	for _, tc := range testcases {
		t.Run(tc.name, func(t *testing.T) {
			<>
		})
	}
}
    ]],
      {
        i(1, "Name"),                       -- Test name
        i(2, "case 1"),                     -- First testcase name
        i(3, 't.Skip("not implemented")'),  -- Function body
      },
      { delimiters = "<>" }
    ))
  },
}
