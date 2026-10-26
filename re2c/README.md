# re2c

re2c is a lexer generator for C/C++.

## Maintainers

* Strip Mall Karate Company

## Type of Package

Binary package

## Usage

If your plan/package requires re2c, you can include it as a build/runtime dependency as necessary:

In your plan:

```
pkg_build_deps=(
  karate/re2c
)
```

This will make `re2c` available on your path, and accessible for your builds.

If you want to run re2c directly, install the package, and run:

```
doj pkg install karate/re2c
doj pkg exec karate/re2c re2c
```

On Linux systems, you can binlink instead, and then simply run the command:

```
doj pkg install --binlink karate/re2c
re2c
```
