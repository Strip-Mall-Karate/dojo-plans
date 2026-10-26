# Dgraph

Dgraph is a distributed, transactiona, graph database written in go

## Maintainers

* Strip Mall Karate Company

## Type of Package

Binary package

## Usage

Usage instructions for Dgraph specifically can be found in their [documentation](https://docs.dgraph.io/get-started/). This package provides the binary only, and can be used as follows:

```
doj pkg install --binlink karate/dgraph
dgraph help
```

Alternatively, it can be run without binlinking:

```
doj pkg install karate/dgraph
doj pkg exec karate/dgraph dgraph help
```
