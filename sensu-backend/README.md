# Dojo package: sensu-backend

## Description

This plan installs & configures the `sensu-backend`.

## Usage

The sensu backend should be using in conjunction with one or more sensu backends. It can be configured to work with a backend via service bindings or through the package configuration.

Ex:
```bash
  doj sup run karate/sensu-backend --peer some.ip --topology standalone --strategy at-once
```

## Testing

Bring up the sensu backend inside of doj studio (and forward ports 3000 and 8080 if on mac).

Ex:
```bash
  DOJ_DOCKER_OPTS="-p 3000:3000 -p 8080:8080" doj studio enter
  build
  doj svc load karate/sensu-backend
```

#### Dashboard

The dashboard is available on port 3000 by default.

Intial credentials are

- user: admin
- password: P@ssw0rd!

These credentials can be changed using the `sensuctl`

https://docs.sensu.io/sensu-core/2.0/getting-started/configuring-sensuctl/#default-user

See also: configuring the sensuctl to work with the backend

https://docs.sensu.io/sensu-core/2.0/getting-started/configuring-sensuctl/
