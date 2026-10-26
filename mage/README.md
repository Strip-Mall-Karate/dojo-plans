# Mage

Mage is a make/rake-like build tool using Go. You write plain-old go functions, and Mage automatically uses them as Makefile-like runnable targets.

## Maintainers

* Strip Mall Karate Company

## Type of Package

Binary Package

## Usage

Mage can be installed/used as a standalone binary:

```
doj pkg install karate/mage
$(doj pkg path karate/mage)/bin/mage

# or binlink

doj pkg install karate/mage
doj pkg binlink karate/mage
mage
```

Alternatively, it can be used in your pacakges build dependencies for running Magefiles.

```
pkg_build_deps=(karate/mage)

do_build() {
  ...
  mage
  ...
}
```
