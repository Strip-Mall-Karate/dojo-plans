# Runc
The `runc` plan _only_ provides users access to the standalone [runc binary](https://github.com/opencontainers/runc). Runc unlike dockerd does not include a running daemon. Instead, it is meant to be executed as a binary or consumed as a library to manage OCI bundle containers.

## Examples
To use the `runc` binary you can follow two different patterns. You can either binlink the package to the underlying system, or you can use the `doj` binary to execute the `img` binary

```
$ doj pkg exec karate/runc runc --help
```
Or
```
$ doj pkg binlink karate/runc runc
$ runc --help
```
