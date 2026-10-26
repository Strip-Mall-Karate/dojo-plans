# Ruby Scaffolding

Builds Ruby web applications, services and processes ("apps") into a Dojo package that the Supervisor
runs: Rails 4.2 and 5 apps, and Rack apps. A plan names the scaffolding and has no source: its directory,
with a `Gemfile` and a `Gemfile.lock`, is the app.

```fennel
{:name "my_app"
 :origin "acmecorp"
 :version "0.1.0"
 :targets ["x86_64-linux"]
 :scaffolding "karate/scaffolding-ruby"}
```

With settings:

```fennel
 :scaffolding {:package "karate/scaffolding-ruby" :settings {:app_port 9000 :env {:GREETING "hi"}}}
```

The scaffolding's package depends on Bundler, Ruby, gcc, make and pkg-config, so a plan using it builds
with them.

- [Quickstart](doc/quickstart.md)
- [Reference](doc/reference.md)

## Settings

| Setting | Meaning | Default |
| ------- | ------- | ------- |
| `ruby_pkg` | The Ruby package | from `Gemfile.lock`'s `RUBY VERSION`, else `karate/ruby` |
| `app_port` | The app's port in `default.toml` | `8000` |
| `env` | More variables for the app's environment, name to value | none |
| `process_bins` | More processes, name to command. They win over detected ones | none |
| `symlinked_dirs` | More app directories to keep under the service's `var` directory | none, or Rails' `log`, `tmp` and `public/system` |

## Troubleshooting

A build without a `Gemfile.lock` fails. Run `bundle lock` in the app and commit the `Gemfile.lock` it
writes.
