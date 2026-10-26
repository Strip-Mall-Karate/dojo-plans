# Dojo package: optipng

OptiPNG is a PNG optimizer that recompresses image files to a smaller size, without losing any information.

## Maintainers

Strip Mall Karate Company.

## Type of package

Binary package. Ships the optipng binary only.

## Usage

You can install this to use the binary, or add it as a dependency for your plans.

As a dependency, place the following in your `plan.sh`:

```
pkg_deps=(
  karate/optipng
)
```

Or to just use the binary:

```
doj pkg install --binlink karate/optipng
optipng myfile.png
```
