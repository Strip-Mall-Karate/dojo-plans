# Open Policy Agent (OPA)

OPA is a lightweight general-purpose policy engine that can be co-located with your service.

## Maintainers

* Strip Mall Karate Company

## Type of Package

Service package

## Usage

Install the package, and load the OPA service:

```
doj pkg install karate/opa
doj svc load karate/opa
```

This will start OPA with the default configuration.

It is started with its default settings -- more complex configuration
should be done in configuration plans.

## CLI usage

The service binary can also be used interactively:

```
# doj pkg exec karate/opa opa run
OPA 0.10.0 (commit dbf54cde-dirty, built at 2018-10-26T07:58:50Z)

Run 'help' to see a list of commands.

> 2+2 == 5
false
>
```

## Bindings

This package exposes the service's address, which can be either
`ip:port`, or a UNIX socket address.

* address
