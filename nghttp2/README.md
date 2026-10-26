# nghttp2

This package provides the nghttp2 library and headers.

[nghttp2](http://nghttp2.org) is a C library for HTTP/2 (for example used by
curl).

The applications included in the nghttp2 sources, nghttpx, nghttpd, nghttp, and
h2load, are *not included* in the dojo package.

## Maintainers

Strip Mall Karate Company

## Type of Package

binary wrapper package

## Usage

To use this library in your application, add `karate/nghttp2` to its `pkg_deps`,
and pass its location to your application's `./configure` call, for example:

```
do_build() {
  ./configure --with-nghttp2="$(pkg_path_for nghttp2)"
  make
}
```
