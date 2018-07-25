;; This file constantly changes to reflect the latest vision of the language.


;; Define a new type `IntPair' with 2 fields: `x' and `y'. Both fields have a type of `Int'.
(type IntPair a Int b Int)

(do ;; Like `progn' in Emacs Lisp, block of forms.
  ;; `var' inside a `do' defines a variable local to that block.
  (var p1 (new IntPair :a 0 :b 1)) ;; Creates [0 1]
  (var p2 (new IntPair :b 1))      ;; Same as above, `a' gets zero value
  (if [p1 = p2]                    ;; Performs field-by-field shallow comparison
      (print "${p1} ${p2}")        ;; Can use string interpolation for vars
    (panic "impossible"))          ;; `panic` is borrowed from Go
  ;; Fields are accessed using `get' special form:
  (get p1 :a) ;; Returns p1 field named `x'
  (get p1 :b) ;; Returns p1 field named `y'
  ;; `set` special form can assign new values to fields:
  (set p1 x (get p1 :y))
  (set p1 y (get p1 :x))
  ;; Both `get' and `set' can only be used inside a package that
  ;; defined the type being accessed. To provide exported getters and setters,
  ;; define a function and export it.
  )
 
;; Return type is written after `->' token.
(func IntPair.a (p IntPair -> Int)    (get p :a))
(func IntPair.b (p IntPair -> Int)    (get p :b))
;; For functions that are not intended to be used as expressions,
;; void-like type is implied.
(func IntPair.set_a (p IntPair a Int) (set p :a a))
(func IntPair.set_b (p IntPair b Int) (set p :b b))
