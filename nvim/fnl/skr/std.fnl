;; std.fnl: standard library functions.

(fn split [str sep]
  "Split str on sep, turning it into a list."
  (let [regex (: "([^%s]+)" :format sep)]
    (icollect [m (str:gmatch regex)] m)))

(fn cut [elems sep]
  "Cut the list elems at the first element that equals sep.

  Returns a two-element list with the elements before and after the sep, or
  errors if there are no sep element in the list.

  Examples:

    (cut [1 2 3 4] 2) ;; [[1] [3 4]]
    (cut [1 2 3 4] 1) ;; [[] [2 3 4]]
    (cut [1 2 3 4] 5) ;; {:error \"no match\"}"
  (fn cut-recursive [before rest]
    (match rest
      ;; Head element matches sep: remove head and return the before after.
      (where [head & after] (= head sep))
      [before after]
      ;; Head element does not match sep: add the head to before, and recurse.
      [head & tail]
      (do
        (table.insert before head)
        (cut-recursive before tail))
      ;; Else we are at the end: error.
      _
      (error (.. "missing element " sep))))

  (cut-recursive [] elems))

{: split : cut}
