local ls = require('luasnip')

local t = ls.text_node
local i = ls.insert_node

ls.snippets = {
  go = {
    ls.snippet("tabletest", {
      t("func Test"), i(1, "Name"), t({
        "(t *testing.T) {",
        "	testcases := []struct{",
        "		name string",
        "	}{",
        "		{",
        "			name: \"testcase\",",
        "		},",
        "	}",
        "	for _, tc := range testcases {",
        "		t.Run(tc.name, func(t *testing.T) {})",
        "	}",
        "}",
      }),
    }),
  },
}
