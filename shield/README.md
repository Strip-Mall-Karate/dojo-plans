# Shield

This is a dojo plan for SHIELD a standalone system that can perform backup and restore functions for a wide variety of pluggable data systems. Please checkout the [github repo](https://github.com/starkandwayne/shield) for more information on the internals and how to use it.

## Dependencies
- shield-proxy (packaged and run as side-car with shield)
- postgresql

## Running shield

First you will need to start postgresql to provide a persistent store for shield:

```
doj start karate/postgresql
```

Then bring up the daemon via:
```
doj start karate/shield --peer <pg-host> --bind database:postgresql.default
```

You can configure shield specific entities via the `shield` cli or by bringing up a `shield-agent` that will provision entities automaticaly.

```
cat <<EOF > agent-config.toml
[schedules]
auto = "daily 4am"
EOF
DOJ_SHIELD_AGENT=$(cat agent-config.toml) doj start karate/shield-agent --peer <shield-host> --bind daemon:shield.default
```

## docker-compose example

Here is how to bring up a complete SHIELD installation with docker-compose

```
cat <<EOF >docker-compose.yml
version: '3'

services:
  shield:
    image: starkandwayne/shield
    command: "start starkandwayne/shield --peer database --bind database:postgresql.shield"
    ports:
    - 443:443
    links:
    - database
  agent:
    image: starkandwayne/shield-agent
    command: "start starkandwayne/shield-agent --peer shield --bind daemon:shield.default"
    environment:
      DOJ_SHIELD_AGENT: |
        [schedules]
        daily='daily 4am'
        [retention-policies]
        shortterm='86400'
    links:
    - shield
  database:
    image: starkandwayne/postgresql:latest
    command: "start starkandwayne/postgresql --group shield"
EOF

docker-compose up
```

Once the containers have come up you can use the shield cli to check that the daily schedule was provisioned.
```
$ shield create-backend doj https://localhost
Successfully created backend 'doj', pointing to 'https://localhost'

Using https://localhost (doj) as SHIELD backend
$ shield schedules -k
Name  Summary  Frequency / Interval (UTC)
====  =======  ==========================
auto           daily 4am
```
