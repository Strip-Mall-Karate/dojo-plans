# Dojo Package: Crate
Strip Mall Karate Company

## Description

- [www](https://www.drupal.org)
- [Docs](https://www.drupal.org/documentation/

> Drupal is content management software. It's used to make many of the
> websites and applications you use every day.

Drupal has great standard features, like easy content authoring,
reliable performance, and excellent security. But what sets it apart
is its flexibility; modularity is one of its core principles. Its
tools help you build the versatile, structured content that dynamic
web experiences need.

## Usage

### Starting

```
doj start karate/drupal --bind database:<database service group> --peer <ip of database service group supervisor>
```

### Stopping

```
doj sup stop karate/nginx
doj sup stop karate/drupal
```

By default, Drupal will be available on port 80.

### Notes

- This package requires a running instance of `karate/mysql` to bind to.
- After starting the service the user is provided with a new Drupal site with preconfigured admin username and password.
