# sqitch_pg
This is a Dojo plan for [Sqitch](http://sqitch.org/) with [DBD-Pg](http://search.cpan.org/dist/DBD-Pg/) which is used to do database deploys to PostgreSQL.

## Maintainers
Strip Mall Karate Company

## Type of Package

This is a hybrid binary + library package, designed to make it easy to install Sqitch for PostgreSQL with a single package definition.

## Usage

Install this package by running:
```
doj pkg install -b karate/sqitch_pg
```

Run this package like so:
```
cd your_schema_folder
doj pkg exec karate/sqitch_pg sqitch --engine pg deploy "db:pg://${USER}:${PASS}@${HOST}/$DB"
```

For a complete example, see the db-migrations script in Chef Server's bookshelf service
