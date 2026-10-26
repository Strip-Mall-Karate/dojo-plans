# Dojo package: postgresql-client

## Description

This plan provides the client binaries for Postgresql.  It can be used both as a client for `karate/postgresql` as well as standalone pgsql installations.  Just as with `karate/postgresql` there are versions that match every point version of Postgres.

## Usage

This mostly provides the postgres binaries (`psql`, `createdb`, etc) to other applications, but users can use/test it via
`doj pkg exec karate/postgresql-client psql <args>`
