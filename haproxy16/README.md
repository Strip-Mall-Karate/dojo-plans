# haproxy

HAProxy is a free, very fast and reliable solution offering high availability, load balancing, and proxying for TCP and HTTP-based applications. It is particularly suited for very high traffic web sites and powers quite a number of the world's most visited ones.

## Maintainers

Strip Mall Karate Company

## Type of Package

This is a service package that will be run by the Dojo supervisor.

## Usage

You can start the service with:

```
$ doj start karate/haproxy16
```

And bind another Dojo service to it - see "Binding" below for more details.

## Bindings

Consuming services can bind to HAProxy via:

```
doj svc load karate/haproxy16 --bind port:haproxy.default
```

## Topologies

This plan currently only supports the standalone topology.

### Standalone

To run a standalone haproxy instance, run

```
doj sup run --topology standalone
doj svc load karate/haproxy16
```

The standalone topology is used by default by the dojo supervisor if none is specified.
For more details on the standalone topology, see the Dojo docs on standalone.

### Leader-Follower

This plan does not make use of the leader/follower topology.

Check out the Dojo docs on Leader-Follower for more details on what the leader-follower topology is and what it does.

## Update Strategies

The authors do not provide any recommendations for how to use update strategies with this package.

Check out the update strategy documentation for information on the strategies Dojo supports.

### Configuration Updates

Check out the configuration update documentation for more information on what configuration updates are and how they are executed.

Take a look at the [default.toml](default.toml) for this package to see the configuration settings you can override.

## Scaling

This package does not currently support high availability on its own.

## Monitoring

This service can be monitored by making TCP connections to the configured port (default is 80)
