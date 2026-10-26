# Elasticsearch5

Elasticsearch is a distributed, RESTful search and analytics engine capable of solving a growing number of use cases.

## Maintainers

* Strip Mall Karate Company

## Type of Package

Service package

## Usage

Install the package, and load the serivce:

```
doj pkg install karate/elasticsearch5
doj svc load karate/elasticsearch5
```

## Bindings

Services consuming Elasticsearch can bind via:

```
doj start origin/package --bind elastic:elasticsearch5.default
```

Elasticsearch's contract presents the following ports to bind to:

* `http-port`
* `transport-port`

## Topologies

Currently this plan supports standalone topology. Pull requests to ease the leader-follower story are welcomed!

## Update Strategies

No update strategy or at-once update strategy works fine in a single-node installation.
