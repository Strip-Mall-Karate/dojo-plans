# msodbcsql17

ODBC driver for SQL server

## Maintainers

* Strip Mall Karate Company

## Type of Package

Binary package

## Usage

Use with unixODBC package.

### Usage example

Include unixODBC and msodbcsql17 as runtime dependencies in your application:

```bash
pkg_deps=(
  karate/msodbcsql17
  karate/unixodbc
)
```

Include odbcinst.ini in your application config:

```
[ODBC Driver 17 for SQL Server]
Description=Microsoft ODBC Driver 17 for SQL Server
Driver={{pkgPathFor "karate/msodbcsql17"}}/lib/libmsodbcsql-17.2.so.0.1
UsageCount=1
```

In your run hook, set ODBCSYSINI environment variable to point at your app config path.

```
export ODBCSYSINI="{{pkg.svc_config_path}}"
```

You can then consume the ODBC driver via application unixODBC bindings.
