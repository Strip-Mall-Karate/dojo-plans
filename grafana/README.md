Grafana in Dojo
====

This Dojo plan installs stock grafana and optionally adds a bound prometheus datasource along with some sample dashboards

Config
---

If run with `--bind prom:<prometheus_service_group` a post-run hook will wait till the grafana service has started then use the API to add the prometheus data source as well as the stock prometheus and node_exporter dashboards.

Basic Usage
----

1) clone this repo
2) install the doj binary (https://github.com/StripMallKarateCompany/dojo)
3) Run these commands:
```
doj studio enter # stay in studio
 build grafana
 doj pkg export docker <yourOrg>/grafana
 # exit studio
docker run -p 3000:80 --name my_grafana <yourOrg>/grafana
```
