# MySQL

This MySQL plan supports standalone and clustered modes

## Standalone

To run a standalone MySQL instance simply run
```
doj start karate/mysql
```

## Cluster

This plan supports running clustered MySQL by utilizing Dojo's native leader election.

You can run an example cluster via docker-compose after exporting a docker container from this plan:
```
$ doj pkg export docker $(ls -1t results/*.hart | head -1)
```

The docker post-process should create a docker image named `karate/mysql` and it should be available on your local machine

example `docker-compose.yml` file:
```
version: '3'
services:
  mysql1:
    image: karate/mysql:latest
    environment:
      DOJ_MYSQL: |
        app_username = 'appadmin'
        app_password = 'SuperSecurePassword42'
        bind = '0.0.0.0'
        root_password = 'EvenMoreSecurePassword2018'
        server_id = 1
    volumes:
      - mysql1-data:/doj/svc/mysql/data
    command: --group cluster
      --topology leader

  mysql2:
    image: karate/mysql:latest
    environment:
      DOJ_MYSQL: |
        app_username = 'appadmin'
        app_password = 'SuperSecurePassword42'
        bind = '0.0.0.0'
        root_password = 'EvenMoreSecurePassword2018'
        server_id = 2
    volumes:
      - mysql2-data:/doj/svc/mysql/data
    command: --peer mysql1
      --group cluster
      --topology leader

  mysql3:
    image: karate/mysql:latest
    environment:
      DOJ_MYSQL: |
        app_username = 'appadmin'
        app_password = 'SuperSecurePassword42'
        bind = '0.0.0.0'
        root_password = 'EvenMoreSecurePassword2018'
        server_id = 3
    volumes:
      - mysql3-data:/doj/svc/mysql/data
    command: --peer mysql1
      --group cluster
      --topology leader

volumes:
  mysql1-data:
  mysql2-data:
  mysql3-data:
```

## Binding

Consuming services can bind to MySQL via:

```
doj start <origin>/<app> --bind database:mysql.default --peer <pg-host>
```

Superuser access is exposed to consumers when binding and we advise that required databases, schemas and roles be created and migrations get run in the init hook of the consuming service. The created roles (with restricted access) should then be exposed to the application code that will get run.

In the template of the consuming service, there is currently a difference between the binding syntax for binding to the leader in a clustered topology vs binding to any member.  A future enhancement may improve upon that, but for now something like this could work if used in an interpreted script file:

```
# Use the eachAlive and @first helpers to bind to the oldest alive member of the bound service group
#   - members are processed in the chronological order of when they joined the ring
# If a later member comes along that is the leader of a cluster topology, override the environment variable definitions with that
#   - if not, the second section is omitted
{{~ #if bind.database}}
  {{~ #eachAlive bind.database.members as |member|}}
    {{~ #if @first}}
# First alive member
DBHOST="{{member.sys.ip}}"
DBPORT="{{member.cfg.port}}"
DBUSER="{{member.cfg.app_username}}"
DBPASSWORD="{{member.cfg.app_password}}"
    {{~ /if}}

    {{~ #if member.leader}}
# Leader node override
DBHOST="{{member.sys.ip}}"
DBPORT="{{member.cfg.port}}"
DBUSER="{{member.cfg.app_username}}"
DBPASSWORD="{{member.cfg.app_password}}"
    {{~ /if}}
  {{~ /eachAlive}}
{{~ /if}}
```

However if you're using more of a rigid configuration file syntax then you still need to know and choose in advance whether or not you're expecting to connect to a leader topology or not.
