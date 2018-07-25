;; This file constantly changes to reflect the latest vision of the language.


;; Define a new type `IntPair' with 2 fields: `x' and `y'. Both fields have a type of `Int'.
;; For every field, getter and setter functions are generated.
;; These functions are not exported and must be exported explicitly.
(type IntPair a Int b Int)

(do ;; Like `progn' in Emacs Lisp, block of forms.
  ;; `var' inside a `do' defines a variable local to that block.
  (var p1 (new IntPair :a 0 :b 1)) ;; Creates [0 1]
  (var p2 (new IntPair :b 1))      ;; Same as above, `a' gets zero value
  (if [p1 = p2]                    ;; Performs field-by-field shallow comparison
      (print "${p1} ${p2}")        ;; Can use string interpolation for vars
    (panic "impossible"))          ;; `panic` is borrowed from Go
  ;; Fields are accessed using `get' special form:
  (p1.a) ;; Calls `IntPair.a' (auto-generated getter)
  (p1.b) ;; Calls `IntPair.b' (auto-generated getter)
  ;; `set` special form can assign new values to fields:
  (p1.a (p1.b)) ;; Calls `IntPair.a' 1-argument overloading (auto-generated setter)
  (p1.b (p1.a)) ;; Calls `IntPair.b' 1-argument overloading (auto-generated setter)
  )
