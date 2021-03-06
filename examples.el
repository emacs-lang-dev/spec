;; This file constantly changes to reflect the latest vision of the language.


;; Define a new type `IntPair' with 2 fields: `first' and `second'. Both fields have a type of `Int'.
;; For every field, getter and setter functions are generated.
;; These functions are not exported and must be exported explicitly.
(type IntPair Int first Int second)

(do ;; Like `progn' in Emacs Lisp, block of forms.
  ;; `var' inside a `do' defines a variable local to that block.
  (var p1 (new IntPair :first 0 :second 1)) ;; Creates [0 1]
  (var p2 (new IntPair :second 1))          ;; Same as above, `first' gets zero value
  (if [p1 = p2]                    ;; Performs field-by-field shallow comparison
      (print "${p1} ${p2}")        ;; Can use string interpolation for vars
    (panic "impossible"))          ;; `panic` is borrowed from Go
  ;; Fields are accessed using auto-generated getters and setter functions.
  (p1.first)  ;; Calls `IntPair.first' 0-argument overloading (auto-generated getter)
  (p1.second) ;; Calls `IntPair.second' 0-argument overloading (auto-generated getter)
  ;; `set` special form can assign new values to fields:
  (p1.first (p1.second)) ;; Calls `IntPair.first' 1-argument overloading (auto-generated setter)
  (p1.second (p1.first)) ;; Calls `IntPair.second' 1-argument overloading (auto-generated setter)
  )

;; Define a `fact' function of type `[(Int) -> Int]'.
(func fact (Int x -> Int)
  (if [n = 1]
    1
    [(fact [n - 1]) * n]))

;; The [(Int) -> Int] is just a more readable way of writing (-> (Int) Int).
;; Other examples of function types:
;;   [() ->]        (-> ())        returns nothing and have no inputs
;;   [(I) ->]       (-> (I))       returns nothing and have a single I argument
;;   [(I) -> R]     (-> (I) R)     returns R and have a single I argument
;;   [(I1 I2) -> R] (-> (I1 I2) R) returns R and have two arguments: I1 and I2
;;   ... and so on
;;
;; It's a preffered to write type expressions using [] notation.

;; There are other parametric builtin types, like:
;;   (List T)     -- proper Lisp list (nil terminated in Emacs Lisp terms)
;;   (Vector T)   -- Emacs Lisp `vector'
;;   (Map K V)    -- Emacs Lisp hash table
;;   (Pair T1 T2) -- Emacs Lisp `cons' object

;; For builtin containers, constructors that can infer result
;; type are provided.
;; These constructors live in a same symbol space as macros,
;; so we can have both `map' function and `map' constructor.
;; (map fn seq) calls a function, {map k v ...} refers to a constructor.
;; It also makes it possible to have a local variable `any' while still
;; being able to use {any x} constructor.
(do
  ;; `vector' result type is inferred to be `(Vector Int)'.
  {vector 1 2 3}
  ;; `vector' result type is inferred to be `(Vector Float)'.
  {vector 1.0 2.0 3.0}
  ;; `vector' result type is inferred to be `(Vector IntPair)'.
  {vector (new IntPair) (new IntPair)}
  ;; You can't use different element types.
  ;; This is done to avoid errors that are hard to detect due to type inference
  ;; and implicit nature of dynamic `Any' vars.
  ;; If you want something like (List Any), be explicit.
  {list {any 1} {any "2"} {any 3.0}}
  ;; Note: even when using 1 literal in place where
  ;; floating-point value is expected, one must write 1.0,
  ;; otherwise it's a type error.
  {map "k1" 1 "k2" 2} ;; (Map Str Int)
  {pair 1 2}          ;; (Pair Int Int)
  {pair 1 2.0}        ;; (Pair Int Float)
  )
