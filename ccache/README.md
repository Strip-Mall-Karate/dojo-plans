# ccache

[ccache][1] is a compiler cache. It speeds up recompilation by caching previous compilations and detecting when the same compilation is being done again.

## Maintainers

* Strip Mall Karate Company

## Type of Package

Binary package

## Usage

To use this plan, include it in your `pkg_build_deps` or `pkg_deps`, for example:

```
pkg_build_deps=(karate/ccache)
```

or use it directly:

```
doj pkg install karate/ccache --binlink
ccache --help
```

[1]: https://ccache.samba.org/
