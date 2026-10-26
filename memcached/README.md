# Memcached

Free & open source, high-performance, distributed memory object caching system, generic in nature, but intended for use in speeding up dynamic web applications by alleviating database load.

## Maintainers

* Strip Mall Karate Company

## Type of Package

Service package

## Usage

Simple usage:

```
doj pkg install karate/memcached
doj svc load karate/memcached
```

Memcached is now available on port `11211` (default).

## Topologies

Memcached server nodes are not aware of each other.

As such, `standalone` is the recommended topology.

## Update Strategies

Update strategies depend on how your application(s) depend on Memcached for operation. Both `at-once` and `rolling` would be appropriate, however the rolling requirement is that a leader-follower topology be used.

## Monitoring

Any network capable monitoring system can connect to the exposed port `11211` (by default) and issue the command `stats` to view basic system information for monitoring purposes.
