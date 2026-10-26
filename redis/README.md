# Redis

Redis is an open source (BSD licensed), in-memory data structure store, used as a database, cache and message broker.

## Maintainers

* Strip Mall Karate Company

## Type of Package

Service package

## Usage

Redis first requires configuration to setup the credentials for protected mode. No defaults are assumed for users of the package.

Example service install / load and setup:

```
doj pkg install karate/redis

echo '
requirepass="password"
' | doj config apply redis.default $(date +%s)

doj svc load karate/redis
```

## Bindings

Redis provides the bind `port` for other services to bind to.

```
doj svc load my/service --bind redis:redis.default
```

## Topologies

The default configuration does not enable clustering. This should be addresed in future Dojo plan releases.

For the moment, a `standalone` topology is possible with the default configuration.

## Update Strategies

An `at-once` strategy would suffice for the standalone installation. If you are running in cluster mode, it is recommended that you employ the `rolling` strategy.
