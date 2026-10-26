# metricbeat

Metricbeat is a lightweight shipper for metrics with Elasticsearch.

## Maintainers

Strip Mall Karate Company.

## Type of package

Service package.

## Usage

```
doj svc load karate/metricbeat
```

Metricbeat will run with the default configuration which puts logs at `{{svc_var_path}}/log/*.log`. The default configuration may not match your needs, and you can replace all of the configuration by providing a user.toml.

## Topologies

Recommended topology is `standalone`.

## Update Strategies

Recommended update strategy is `at-once`.
