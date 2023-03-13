(local {:text_node t
        :insert_node i
        :choice_node c
        :dynamic_node d
        :func_literal f
        :snippet mk-snippet} (require :luasnip))

(local {:fmt extras/fmt} (require :luasnip.extras.fmt))
(local {: nil? : not-nil?} (require :skr.std))

(fn fmt [snippet args]
  "Creates a fmt node, but defaults to the delimiters `<>` since `{}` are
  already pretty well used in go."
  (extras/fmt snippet args {:delimiters "<>"}))

(local snippet-test-table
       (let [snippet "func Test<>(t *testing.T) {
\ttests := []struct{
\t\tname string
\t}{
\t\t{
\t\t\tname: \"<>\",
\t\t},
\t}
\tfor _, tt := range tests {
\t\tt.Run(tt.name, func(t *testing.T) {
\t\t\t<>
\t\t})
\t}
}"
             args [(i 1 :Name)
                   (i 2 "case 1")
                   (i 3 "t.Skip(\"not implemented yet\")")]
             root (fmt snippet args)]
         (mk-snippet :testtable root)))

(local snippet-iferr (let [snippet "if err != nil {
\treturn fmt.Errorf(\"<>: %w\", err)
}"
                           args [(i 1 "")]
                           root (fmt snippet args)]
                       (mk-snippet :iferr root)))

(fn setup-treesitter-query []
  (vim.treesitter.set_query :go :return-value "[
      (method_declaration result: (_) @ret)
      (function_declaration result: (_) @ret)
      (func_literal result: (_) @ret)
    ]"))

(fn nil-value [type-str]
  "Get the zero value of a go type."
  (fn is-ptr? [x] (not-nil? (x:find "^%*")))

  (fn is-int? [x] (not-nil? (x:find :^u?int)))

  (fn is-chan? [x] (not-nil? (x:find :^<?-?chan)))

  ;; TODO: things not handled:
  ;;   - non-builtin user types (needs LSP calls for some of these?)
  ;;     - structs      -> myStruct{}
  ;;     - interfaces   -> nil
  ;;     - newtypes     -> myType(${underlying-type-zero-value})
  ;;     - type aliases -> get underlying type
  ;;   - complex numbers (lol)
  (match type-str
    (where x (is-ptr? x)) :nil
    (where x (is-chan? x)) :nil
    (where x (is-int? x)) :0
    :bool :false
    :string "\"\""
    :error :err
    _ :nil))

(fn get-return-values []
  (local {:get_node_at_cursor get-node} (require :nvim-treesitter.ts_utils))
  (local {:get_scope_tree get-scope} (require :nvim-treesitter.locals))
  ;; Get the node of the closest func definition from the current node.
  ;; TODO: early breaks would be nice here...
  (local scope (get-scope (get-node) 0))
  (var func-node nil)
  (each [_ v (ipairs scope)]
    (let [t (v:type)
          correct-type (or (= t :function_declaration)
                           (= t :method_declaration) (= t :func_literal))
          not-set (nil? func-node)]
      (when (and correct-type not-set)
        (set func-node v))))
  ;; Do query and get the zero values of the return types.
  (local query (vim.treesitter.get_query :go :return-value))
  (var ret-values [])
  (each [_ node (query:iter_captures func-node 0)]
    (for [i 0 (- (node:named_child_count) 1)]
      (let [child (node:named_child i)
            ret-type (vim.treesitter.get_node_text child 0)
            nil-val (nil-value ret-type)]
        (table.insert ret-values nil-val))))
  (print (table.concat ret-values ", ")))

(fn snippet-iferrv2 []
  (local snippet "if err != nil {\n\treturn <>\n}")
  (local args [(f 1 get-return-values)])
  (local root (fmt snippet args))
  (mk-snippet :iferrv2 root))

(fn setup []
  (setup-treesitter-query))

(local snippets [snippet-test-table
                 ;;snippet-iferrv2
                 snippet-iferr])

{: setup : snippets}
