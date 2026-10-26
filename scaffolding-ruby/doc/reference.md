# Ruby Scaffolding

Ruby Scaffolding builds Ruby web applications, services and processes ("apps") into a Dojo package that
the Supervisor runs. Start with the [quickstart](quickstart.md).

## The plan and the app

A plan names the scaffolding and has no `:source`. The directory holding `plan.fnl` is the app, and it
must have a [`Gemfile`][] and a `Gemfile.lock`:

```
.
├── Gemfile
├── Gemfile.lock
└── plan.fnl
```

The plan can also be `dojo/plan.fnl`, and the directory above `dojo/` is then the app:

```
.
├── Gemfile
├── Gemfile.lock
└── dojo
    └── plan.fnl
```

The plan names the scaffolding as a package, or as a table with settings:

```fennel
 :scaffolding "karate/scaffolding-ruby"
```

```fennel
 :scaffolding {:package "karate/scaffolding-ruby" :settings {:app_port 9000}}
```

## Gemfile.lock

The scaffolding reads `Gemfile.lock` for the app type, the gems that need packages and the Ruby version.
A missing `Gemfile.lock` is an error. Run `bundle lock` and add the file to the app.

## Settings

| Setting | Meaning | Default |
| ------- | ------- | ------- |
| `ruby_pkg` | The Ruby package | see [Ruby version](#ruby-version) |
| `app_port` | The app's port in `default.toml` | `8000` |
| `env` | More variables for the app's environment, name to value | none |
| `process_bins` | More processes, name to command. They win over detected ones | none |
| `symlinked_dirs` | More app directories to keep under the service's `var` directory | none |

## What the scaffolding adds to the plan

- `:deps`: the Ruby package, the packages the app's gems need (below) and `karate/busybox-static`,
  which the process bins use as their shell.
- `:build_deps`: `karate/git`.
- `:bin_dirs`: `bin` and `app/binstubs`.
- `:exports`: `port`, from `app.port`.
- `:svc`: `{:run "<name>-web"}`, unless the plan sets `:svc {:run ...}` itself.
- `:binds_optional`: `database`, when the app uses PostgreSQL.

Lists gain the scaffolding's entries, and whatever the plan sets itself stays the plan's. The
scaffolding's own package depends on `karate/bundler`, `karate/ruby`, `karate/gcc`, `karate/make` and
`karate/pkg-config`, so the build has them.

### Packages for gems

| Gem in `Gemfile.lock` | Added to `:deps` |
| --------------------- | ---------------- |
| `sqlite3` | `karate/sqlite` |
| a PostgreSQL gem (see [PostgreSQL](#postgresql)) | `karate/postgresql` |
| `nokogiri` | `karate/libxml2`, `karate/libxslt` |
| `execjs` | `karate/node` |
| `webpacker` | `karate/yarn` |

### Run and build dependencies

The plan's own `:deps` and `:build_deps` add packages. An app using the [rbnacl][] gem, which binds to
[libsodium][], and running ImageMagick's `mogrify` needs both at runtime:

```fennel
{:name "my_app"
 :origin "acmecorp"
 :version "0.1.0"
 :targets ["x86_64-linux"]
 :scaffolding "karate/scaffolding-ruby"
 :deps ["karate/imagemagick" "karate/libsodium"]}
```

A tool needed only to build the app goes in `:build_deps`:

```fennel
 :build_deps ["karate/rust"]
```

## Ruby version

The Ruby package is the first of:

1. The `ruby_pkg` setting, a package with a `ruby` program.
2. `RUBY VERSION` in `Gemfile.lock`, as `karate/ruby/<version>`.
3. `karate/ruby`.

Bundler writes `RUBY VERSION` when the `Gemfile` uses the [`ruby`][gemfile_ruby] keyword:

```ruby
source "https://rubygems.org"

ruby "2.5.5"
```

The patch level is dropped, so `ruby 2.5.5p157` gives `karate/ruby/2.5.5`. The version must be one that
`karate/ruby` is built at. For another Ruby, set the package:

```fennel
 :scaffolding {:package "karate/scaffolding-ruby" :settings {:ruby_pkg "karate/ruby24"}}
```

## The build

Bundler installs the gems into the build's cache with `--deployment`, `--without development:test` and
`--retry 5`. A `.bundle/config` in the app is set aside during the install and put back after it.
The installed cache of `.gem` files is removed, and the `#!` line of each gem program is changed
to the Ruby package's `ruby`.

## The installed app

The package holds the app under `app/`. In a Git checkout the app's files are those Git lists, tracked or
untracked but not ignored. Otherwise they are all the files in the directory. `dojo/`, `results/`,
`vendor/bundle`, version control directories and backup files are left out.

The package also holds:

- The gems in `app/vendor/bundle`.
- Binstubs for the gems in `app/binstubs`, with Bundler's `bundle` and `bundler`.
- `libexec/is_db_connected`, which the init hook runs for a PostgreSQL app.

When the app has the `rake` gem, a Rakefile and a Rake `assets:precompile` task, the build runs it with
`RACK_ENV`, and for Rails `RAILS_ENV`, set to `production`. `DATABASE_URL` is the build's, or a placeholder when the
build has none.

### Symlinked directories

Each directory in `symlinked_dirs`, and Rails' `log`, `tmp` and `public/system`, is replaced in the
installed app by a link to `/doj/svc/<name>/var/<dir>`. The generated init hook creates those
directories.

```fennel
 :scaffolding {:package "karate/scaffolding-ruby" :settings {:symlinked_dirs ["storage"]}}
```

## Process bins

Each process the app runs, a [service or a task][12factor_processes], gets a process bin:
`bin/<name>-<process>` in the package. A process bin sources the app's environment, changes to the
installed app's directory and runs its command. It stops with an error when the service has not
written its environment file yet.

The processes come from, in order of precedence:

1. The `process_bins` setting.
2. A [`Procfile`][] in the app's directory. Lines starting with `#` are skipped.
3. The app type's defaults (see [App type detection](#app-type-detection)).
4. `rake`: `bundle exec rake`, when the app has the `rake` gem and a `Rakefile`, `rakefile`,
   `rakefile.rb` or `Rakefile.rb`.
5. `sh`: a shell with the app's environment in the app's directory.

`web` is the service the package runs, `<name>-web`, unless the plan sets `:svc {:run ...}`.

For an app named `my_app` with this `Procfile`:

```
web: bundle exec puma -t 5:5 -p $PORT
release: bundle exec rake db:migrate
```

the package has `my_app-web` and `my_app-release` in `bin/`, on the package's `PATH`, with the app
type's other processes. The same processes as a setting:

```fennel
 :scaffolding {:package "karate/scaffolding-ruby"
               :settings {:process_bins {:web "bundle exec puma -t 5:5 -p $PORT"
                                         :release "bundle exec rake db:migrate"}}}
```

## App environment variables

The scaffolding writes the app's [environment][12factor_config] to `config/app_env.sh`, a template the
Supervisor renders at runtime. Each process bin and the generated init hook source it.

The defaults for every app are:

- `LANG`: `{{cfg.lang}}`
- `PORT`: `{{cfg.app.port}}`

The app type and PostgreSQL add more, below. The `env` setting adds variables and wins over a default of
the same name:

```fennel
 :scaffolding {:package "karate/scaffolding-ruby"
               :settings {:env {:MY_PKG_VERSION "0.1.0"
                                :AWS_DEFAULT_REGION "{{cfg.aws_default_region}}"}}}
```

A value with handlebars templating is rendered from the service's config at runtime. A value without it
is fixed when the package is built.

## Init hook

When the plan has no `hooks/init`, the scaffolding writes one that:

- sets `HOME` to the service's `data` directory and sources the app's environment
- creates the symlinked directories under the service's `var` directory
- for a Rails app, stops with exit code 5 when `SECRET_KEY_BASE` is empty
- for a PostgreSQL app, stops with exit code 15 and lists the `db` settings when
  `libexec/is_db_connected` cannot connect

A plan with its own `hooks/init` does none of this for it.

## Config settings

The scaffolding writes defaults to the package's `default.toml`, for keys the plan's own `default.toml`
does not set:

- `lang`: `"en_US.UTF-8"`, the app's `LANG`.
- `app.port`: the `app_port` setting, or `8000`. It sets `PORT` and the exported `port`, the
  [port binding][12factor_port] contract.

When the plan's `default.toml` has an `[app]` table, the scaffolding adds no `app.port`. The app type and
PostgreSQL add more, below.

The plan's own config settings go in `default.toml` beside `plan.fnl`:

```
.
├── Gemfile
├── Gemfile.lock
├── default.toml
└── plan.fnl
```

## Service bindings

The scaffolding adds a binding only for [PostgreSQL](#postgresql). A plan declares its own with `:binds`.
A required binding to an [Elasticsearch][] service group:

```fennel
 :binds {:elasticsearch ["http-port" "transport-port"]}
```

Start the service with the binding:

```sh
doj start acmecorp/my_app --bind elasticsearch:es.my_app
```

## App type detection

The app type comes from the `railties` and `rack` gems in `Gemfile.lock`, first match first:

| Gems | App type |
| ---- | -------- |
| `railties` >= 5.0.0 and < 6.0.0 | Rails 5 |
| `railties` >= 4.2.0 and < 5.0.0 | Rails 4.2 |
| `railties` >= 2.0.0 and < 4.2.0 | Rails 2 to 4.1: an error, not supported |
| `rack` | Rack |
| neither | an error, not supported |

Rails 6 and later have no app type, so an app using them is detected as Rack (`rack` is one of Rails'
gems).

### Rails 5 and Rails 4.2

A Rails 5 app must have the `tzinfo-data` gem, and a Rails 4.2 app the `rails_12factor` gem. The build
fails without it.

Default process bins:

- `web`: `bundle exec rails server -p $PORT`
- `console`: `bundle exec rails console`

Default environment variables:

- `RAILS_ENV`: `{{cfg.rails_env}}`
- `RACK_ENV`: `{{cfg.rack_env}}`
- `RAILS_SERVE_STATIC_FILES`: `enabled`
- `SECRET_KEY_BASE`: `{{cfg.secret_key_base}}`
- `RAILS_LOG_TO_STDOUT`: `enabled`, for Rails 5. It [streams the app's logs][12factor_logs] to
  standard output. A Rails 4.2 app gets the same from `rails_12factor`.

Default config settings:

- `rails_env`: `"production"`
- `rack_env`: `"production"`
- `secret_key_base`: `""`. It must be set, and the init hook stops without it. `rails secret` makes
  one.

Rails apps also get `log`, `tmp` and `public/system` as [symlinked directories](#symlinked-directories).

### Rack

Default process bins:

- `web`: `bundle exec rackup config.ru -p $PORT`
- `console`: `bundle exec irb`

Default environment variable `RACK_ENV`: `{{cfg.rack_env}}`, and config setting `rack_env`:
`"production"`.

## PostgreSQL

The app uses PostgreSQL when `Gemfile.lock` has any of these gems:

- `pg`
- `activerecord-jdbcpostgresql-adapter`
- `jdbc-postgres`
- `jdbc-postgresql`
- `jruby-pg`
- `rjack-jdbc-postgres`
- `tgbyte-activerecord-jdbcpostgresql-adapter`

With `activerecord-postgis-adapter`, set `db.adapter` to `postgis` for PostGIS's functions.

### Environment variable

`DATABASE_URL` is `<adapter>://<user>:<password>@<host>:<port>/<name>`, rendered at runtime from:

- `db.adapter`, or `postgresql`
- `db.user` and `db.password`
- the `database` binding's first member's IP, else `db.host`, else `db.host.not.set`
- the `database` binding's `port`, else `db.port`, else `5432`
- `db.name`

### Config settings

Written when the plan's `default.toml` has no `[db]` table:

- `db.adapter`: `"postgresql"`
- `db.name`: `"<name>_production"`
- `db.user`: `"<name>"`
- `db.password`: `"<name>"`. Use a different, random password in production.

`db.host` and `db.port` have no defaults. Set `db.host` when the service runs without a binding.

### Service binding

The scaffolding adds an optional binding, `database`, which needs the `port` config. Bind it to a
PostgreSQL service group:

```sh
doj start acmecorp/my_app --bind database:postgresql.default
```

Without the binding, the database is outside the Dojo ring, and `db.host` must be set.

[12factor_config]: https://12factor.net/config
[12factor_logs]: https://12factor.net/logs
[12factor_port]: https://12factor.net/port-binding
[12factor_processes]: https://12factor.net/processes
[Elasticsearch]: https://www.elastic.co/products/elasticsearch
[`Gemfile`]: https://bundler.io/man/gemfile.5.html
[gemfile_ruby]: https://bundler.io/man/gemfile.5.html#RUBY
[libsodium]: https://doc.libsodium.org/
[`Procfile`]: https://devcenter.heroku.com/articles/procfile
[rbnacl]: https://github.com/RubyCrypto/rbnacl
