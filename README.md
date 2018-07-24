> Version: early draft, unversioned

# Introduction

The language specified in this document can be described by these traits:

* Statically and strongly typed (with the exception of `any` type).
* Uses Lisp syntax, but makes several step asides in favor of code readability (see "syntax sugar" section).
* Designed to be embedded into Emacs. Can call Emacs Lisp functions.

**TODO**: make a decision between Lisp-1 and Lisp-2 model.

# Type system

## Primitive types

All type names are required to start from a capital letter.

Types listed below map in 1-to-1 fashion with Emacs Lisp builtin types:

* `Int` - 32-bit or 64-bit signed integer value.
* `Float` - double precision (64-bit) floating point value.

**TODO**: fill other types as soon as we're sure what else to include here.

## Containers

**TODO**: describe provided containers and their properties.

# Syntax sugar

## Infix and postfix notations

The code inside `[]` is re-written using these rules:

```elisp
[x seconds] => (seconds x)   ;; 2 arguments can be used as a postfix notation
[x < y]     => (< x y)       ;; 3 arguments are a pure infix notation
[x + y * 2] => (* (+ x y) 2) ;; Last infix expression result can be chained
;; The last form is equivalent of [[x + y] * 2]
```

## Dot-call syntax

Functions and methods can be called using dot-call notation.

```elisp
;; object type is T (concrete or interface).
(object.fn x y) => (invoke object fn x y)
;; A. (T-fn object x y)         if T is concrete
;; B. (virt-call fn object x y) if T is an interface
```

`invoke` behavior depends on the `object` static type.

For concrete types, simple call is generated that invokes `${typename}-${fn}` function.
> Example: if type is `point` and fn is `x`, `(pt.x)` is de-sugared into `(point-x)`.

For interface types, virtual function call is generated.

# Packages

All symbols are associated to some package, and exactly one package.

Files that follow `pkgname~filename` pattern define symbols for `pkgname`.
Other files and code inside buffers that are not bound to any file define
symbols for the global package.

All files that are intended to be loaded by the Emacs when `import` is met
should be under lookup path list. Every such path is scanned for filenames.
This filename knowledge is later used to do a lazy package loading when
it is required for first time.

**TODO**: define how circular dependencies are handled.

# Compilation

## Compilation stages

1. Syntax de-sugaring.
2. Packages and imports resolution.
3. Macro expansion.
4. Type checks.
5. Code generation.

Before anything else happens, syntax sugar is re-written into the full
syntactical form. There are no ways to prevent this from happening,
so macro with `[x + y]` argument will receive `(+ x y)` no matter what.
