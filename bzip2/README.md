# bzip2

[bzip2][1] is a freely available, patent free (see below), high-quality data compressor.

## Maintainers

* Strip Mall Karate Company

## Type of Package

Binary package

## Usage

To use this plan, include it in your `pkg_build_deps` or `pkg_deps`, for example:

```
pkg_build_deps=(karate/bzip2)
```

or use it directly:

```
doj pkg install karate/bzip2 --binlink
bzip2
```

[1]: http://www.bzip.org/
