;; std.fnl: standard library functions.

(lambda empty? [seq]
  "Returns true if the sequence is empty.

  Examples:
  ```fennel
  (empty? [])      ; => true
  (empty? [1 2 3]) ; => false
  ```"
  (-> (length seq)
      (= 0)))

(fn nil? [x]
  "Checks if the value is nil (explicitly).

  Examples:
  ```fennel
  (nil? nil) ; => true
  (nil? 5)   ; => false
  ```"
  (= nil x))

(fn not-nil? [x]
  "Checks if the value is non-nil."
  (not= nil x))

(lambda any? [predicate seq]
  "Finds if the predicate is true for any value in the sequence.

  Examples:
  ```fennel
  (any? #(= $ 1) [1 2 3]) ; => true
  (any? #(= $ 4) [1 2 3]) ; => false
  ```"
  (accumulate [found? false _ value (ipairs seq) :until found?]
    (predicate value)))

(lambda all? [predicate seq]
  "Finds if the predicate is true for all values in the sequence.

  Examples:
  ```fennel
  (all? #(= $ 2) [2 2 2 2]) ; => true
  (all? #(= $ 2) [2 2 2 1]) ; => false
  ```"
  (accumulate [found? true _ value (ipairs seq) :until (not found?)]
    (predicate value)))

(lambda split [str sep]
  "Split str on sep, turning it into a list.

  Examples:
  ```fennel
  (split \"1,2,3\" \",\") ; => [1 2 3]
  ```"
  (let [regex (: "([^%s]+)" :format sep)]
    (icollect [m (str:gmatch regex)] m)))

(lambda cut [elems sep]
  "Cut the list elems at the first element that equals sep.

  Returns a two-element list with the elements before and after the sep, or
  errors if there are no sep element in the list.

  Examples:
  ```fennel
  (cut [1 2 3 4] 2) ; => [[1] [3 4]]
  (cut [1 2 3 4] 1) ; => [[] [2 3 4]]
  (cut [1 2 3 4] 5) ; => {:error \"no match\"}
  ```"
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
      (error (.. "missing element " sep)))))

{: empty? : nil? : not-nil? : any? : all? : split : cut}

