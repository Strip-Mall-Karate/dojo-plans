# Apache Ant

[Apache Ant][1] is a Java library and command-line tool whose mission is to drive processes described in build files as targets and extension points dependent upon each other.

## Maintainers

* Strip Mall Karate Company.

## Type of package

Binary package

## Usage

To use this plan, include it in your `pkg_build_deps`.

```
pkg_build_deps=(karate/ant)
```

You will also need to set the `JAVA_HOME` environment variable, for example:

```
export JAVA_HOME=$(doj pkg path karate/corretto8)
```

[1]: https://ant.apache.org/index.html
