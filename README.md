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
