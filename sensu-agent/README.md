# Dojo package: sensu-agent

## Description

This plan installs & configures the `sensu-agent`.

## Usage

The sensu agent should be used in conjunction with one or more sensu backends. It can be configured to work with a backend via service bindings or through the package configuration.

Ex:
```bash
  doj sup run karate/sensu-agent --bind backend:sensu-backend.default --peer some.ip --topology standalone --strategy at-once
```



See also: configuring the sensuctl to work with the backend

https://docs.sensu.io/sensu-core/2.0/getting-started/configuring-sensuctl/
