# jo

This package provides the jo binary.

[jo](https://github.com/jpmens/jo) is a utility to create JSON objects on the
command line.

## Maintainers

Strip Mall Karate Company

## Type of Package

binary wrapper package

## Usage

```
$ doj pkg install karate/jo
$ doj pkg binlink karate/jo
$ jo -h
Usage: jo [-a] [-B] [-p] [-v] [-V] [word...]
        word is key=value or key@value
        -a creates an array of words
        -B disable boolean true/false
        -p pretty-prints JSON on output
        -v show version
        -V show version in JSON jo
$ jo -p foo=bar baz=$(jo -a x y z) true@1
{
   "foo": "bar",
   "baz": [
      "x",
      "y",
      "z"
   ],
   "true": true
}
```
