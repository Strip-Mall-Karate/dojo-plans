# Node Scaffolding

Builds [Node.js][node] web applications, services and processes ("apps") into a Dojo package that the
Supervisor runs. A plan names the scaffolding and has no source: its directory, with a `package.json`,
is the app.

```fennel
{:name "my_app"
 :origin "acmecorp"
 :version "0.1.0"
 :targets ["x86_64-linux"]
 :scaffolding "karate/scaffolding-node"}
```

With settings:

```fennel
 :scaffolding {:package "karate/scaffolding-node" :settings {:app_port 9000 :env {:GREETING "hi"}}}
```

- [Quickstart](doc/quickstart.md)
- [Reference](doc/reference.md)

## Settings

| Setting | Meaning | Default |
| ------- | ------- | ------- |
| `pkg_manager` | `"npm"` or `"yarn"` | detected from the lock file |
| `node_pkg` | The Node package | from `engines.node`, then `.nvmrc`, then `karate/node` |
| `app_port` | The app's port in `default.toml` | `8000` |
| `env` | More variables for the app's environment, name to value | none |
| `process_bins` | More processes, name to command. They win over detected ones | none |

## Build scripts

`npm install` runs with `--unsafe-perm`, so the package's lifecycle scripts run during the build. The
build sets `NODE_ENV=development`, so development dependencies are there for them.

[node]: https://nodejs.org/en/
