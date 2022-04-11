(local ls (require :luasnip))
(local extras-fmt (require :luasnip.extras.fmt))
(local t ls.text_node)
(local i ls.insert_node)
(local c ls.choice_node)

(fn fmt [snippet args]
  "Creates a fmt node, but defaults to the delimiters `<>` since `{}` are
  already pretty well used in go."
  (let [fmt-orig extras-fmt.fmt]
    (fmt-orig snippet args {:delimiters "<>"})))

(local snippet-test-table
  (let [snippet
"func Test<>(t *testing.T) {
	testcases := []struct{
		name string
	}{
		{
			name: \"<>\",
		},
	}
	for _, tc := range testcases {
		t.Run(tc.name, func(t *testing.T) {
			<>
		})
	}
}"
        args [(i 1 "Name")
              (i 2 "case 1")
              (i 3 "t.Skip(\"not implemented yet\")")]
        root (fmt snippet args)]
    (ls.snippet "testtable" root)))

(local snippet-iferr
  (let [snippet
"if err != nil {
	return fmt.Errorf(\"<>: %w\", err)
}"
        args [(i 1 "")]
        root (fmt snippet args)]
      (ls.snippet "iferr" root)))

{:snippets [snippet-test-table
            snippet-iferr]}
