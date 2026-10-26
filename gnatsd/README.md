# Package Name

High-Performance server for NATS, the cloud native messaging system.

## Maintainers

* Strip Mall Karate Company

## Type of Package

Service package

## Usage

Install the package, and laod the gnatsd service:

```
doj pkg install karate/gnatsd
doj svc load karate/gnatsd
```

This will start gnatsd with the default configuration.

## Bindings

This package exposes a NATS port and HTTP port:

* port
* http_port

These can be used for binding to, from other plans.
