# bzip2-musl

[bzip2][1] is a freely available, patent free (see below), high-quality data compressor.

This package is built with [musl-libc][2].

## Maintainers

* Strip Mall Karate Company

## Type of Package

Binary package

## Usage

To use this plan, include it in your `pkg_build_deps` or `pkg_deps`, for example:

```
pkg_build_deps=(karate/bzip2-musl)
```

or use it directly:

```
doj pkg install karate/bzip2-musl --binlink
bzip2
```

[1]: http://www.bzip.org/
[2]: https://www.musl-libc.org
