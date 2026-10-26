# Node Scaffolding

Node Scaffolding builds Node.js web applications, services and processes ("apps") into a Dojo package
that the Supervisor runs. Start with the [quickstart](quickstart.md).

## The plan and the app

A plan names the scaffolding and has no `:source`. The directory holding `plan.fnl` is the app, and it
must have a [`package.json`][]:

```
.
├── package.json
└── plan.fnl
```

The plan can also be `dojo/plan.fnl`, and the directory above `dojo/` is then the app:

```
.
├── package.json
└── dojo
    └── plan.fnl
```

The plan names the scaffolding as a package, or as a table with settings:

```fennel
 :scaffolding "karate/scaffolding-node"
```

```fennel
 :scaffolding {:package "karate/scaffolding-node" :settings {:pkg_manager "yarn" :app_port 9000}}
```

## Settings

| Setting | Meaning | Default |
| ------- | ------- | ------- |
| `pkg_manager` | `"npm"` or `"yarn"`. Any other value is an error | see [Package manager](#package-manager) |
| `node_pkg` | The Node package | see [Node version](#node-version) |
| `app_port` | The app's port in `default.toml` | `8000` |
| `env` | More variables for the app's environment, name to value | none |
| `process_bins` | More processes, name to command. They win over detected ones | none |

## What the scaffolding adds to the plan

- `:deps`: the Node package and `karate/busybox-static`, which the process bins use as their shell.
- `:build_deps`: `karate/git`, and `karate/yarn` when the package manager is Yarn.
- `:bin_dirs`: `bin` and `app/node_modules/.bin`.
- `:exports`: `port`, from `app.port`.
- `:svc`: `{:run "<name>-web"}`, unless the plan sets `:svc {:run ...}` itself.
- From `package.json`: `description`, `license`, `author` (or `author.name`) as the maintainer, and
  `homepage` as the upstream URL.

Lists gain the scaffolding's entries, and whatever the plan sets itself stays the plan's.

### Run and build dependencies

The plan's own `:deps` and `:build_deps` add packages. An app that runs ImageMagick's `mogrify` at
runtime needs it in `:deps`:

```fennel
{:name "my_app"
 :origin "acmecorp"
 :version "0.1.0"
 :targets ["x86_64-linux"]
 :scaffolding "karate/scaffolding-node"
 :deps ["karate/imagemagick"]}
```

A tool needed only to build the app goes in `:build_deps`:

```fennel
 :build_deps ["karate/makesmall"]
```

## Node version

The Node package is the first of:

1. The `node_pkg` setting, a package with a `node` program.
2. `engines.node` in `package.json`, matched against the Node packages this repository builds.
3. The version in `.nvmrc`, as `karate/node/<version>`.
4. `karate/node`.

### engines.node

The Node packages this repository builds are:

| Package | Version |
| ------- | ------- |
| `karate/node6` | 6.14.4 |
| `karate/node8` | 8.15.0 |
| `karate/node9` | 9.0.0 |
| `karate/node10` | 10.15.2 |
| `karate/node` | 11.13.0 |

`engines.node` is a version, optionally after one operator: `=`, `>=`, `<=`, `>` or `<`. A version with
no operator, or with `=`, matches exactly. The scaffolding picks the newest package that meets the
constraint, and fails when none does.

```json
{
  "name": "my_app",
  "version": "0.1.0",
  "engines": { "node": "<=10.15.2" }
}
```

This picks `karate/node10`. Missing parts of a version count as 0, so `"8"` means exactly 8.0.0, which
no package meets. Write `"8.15.0"` or `"<9"` for `karate/node8`. Other forms, such as `^8`, `~8.1`,
`8.x` or a range with two bounds, are an error.

### .nvmrc

When `package.json` has no `engines.node`, the contents of [`.nvmrc`][] give the package:

```
> cat .nvmrc
11.13.0
```

This gives `karate/node/11.13.0`. The version must be one that `karate/node` is built at.

### The node_pkg setting

```fennel
 :scaffolding {:package "karate/scaffolding-node" :settings {:node_pkg "karate/node8"}}
```

## Package manager

The package manager is the first of:

1. The `pkg_manager` setting.
2. [npm][], when the app has a `package-lock.json`.
3. [Yarn][], when the app has a `yarn.lock`.
4. npm.

An app with both a `package-lock.json` and a `yarn.lock` is an error.

npm is the one that ships with the Node package. npm installs the dependencies in a directory of the
build's cache, from copies of `package.json`, `.npmrc`, `npm-shrinkwrap.json`, `gulpfile.ts`,
`tsconfig.json`, `tsoa.json` and `tools/`. It records `npm list --json` as `npm-list.json` in the
package's app directory, unless the app has its own.

Yarn runs `yarn install --pure-lockfile --ignore-engines` in the app's directory, and the build copies
the resulting `node_modules`.

The build runs with `NODE_ENV=development`, so development dependencies are installed. When the app is
in Git and has a `node_modules` that Git does not ignore, the build warns and does not use it. The
`#!` line of each tool in `node_modules/.bin` is changed to the Node package's `node`.

## The installed app

The package holds the app under `app/`, with the `node_modules` the build installed. In a Git checkout
the app's files are those Git lists, tracked or untracked but not ignored. Otherwise they are all the
files in the directory. `dojo/`, `results/`, `node_modules/`, version control directories and backup
files are left out.

## Process bins

Each process the app runs, a [service or a task][12factor_processes], gets a process bin:
`bin/<name>-<process>` in the package. A process bin sources the app's environment, changes to the
installed app's directory and runs its command. It stops with an error when the service has not
written its environment file yet.

The processes come from, in order of precedence:

1. The `process_bins` setting.
2. A [`Procfile`][] in the app's directory. Lines starting with `#` are skipped.
3. `scripts.start` in `package.json`, as `web`. No other script becomes a process.

Every app also gets `sh`, a shell with the app's environment in the app's directory.

`web` is the service the package runs, `<name>-web`, unless the plan sets `:svc {:run ...}`. An app
with no `web` process and no `:svc {:run ...}` is an error.

For an app named `my_app` with this `Procfile`:

```
web: node server.js -p $PORT
release: node scripts/migrate_db.js
```

the package has `my_app-web`, `my_app-release` and `my_app-sh` in `bin/`, on the package's `PATH`.
The same processes as a setting:

```fennel
 :scaffolding {:package "karate/scaffolding-node"
               :settings {:process_bins {:web "node server.js -p $PORT"
                                         :release "node scripts/migrate_db.js"}}}
```

## App environment variables

The scaffolding writes the app's [environment][12factor_config] to `config/app_env.sh`, a template the
Supervisor renders at runtime. Each process bin and the generated init hook source it.

The defaults are:

- `PORT`: `{{cfg.app.port}}`
- `NODE_ENV`: `{{cfg.node_env}}`

The `env` setting adds variables and wins over a default of the same name:

```fennel
 :scaffolding {:package "karate/scaffolding-node"
               :settings {:env {:MY_PKG_VERSION "0.1.0"
                                :AWS_DEFAULT_REGION "{{cfg.aws_default_region}}"}}}
```

A value with handlebars templating is rendered from the service's config at runtime. A value without it
is fixed when the package is built.

## Init hook

When the plan has no `hooks/init`, the scaffolding writes one that sets `HOME` to the service's `data`
directory and sources the app's environment. A plan with its own `hooks/init` does neither for it.

## Config settings

The scaffolding writes these defaults to the package's `default.toml`, for keys the plan's own
`default.toml` does not set:

- `node_env`: `"production"`, the app's `NODE_ENV`.
- `app.port`: the `app_port` setting, or `8000`. It sets `PORT` and the exported `port`, the
  [port binding][12factor_port] contract. The app must listen on `PORT` to keep it.

When the plan's `default.toml` has an `[app]` table, the scaffolding adds no `app.port`.

The plan's own config settings go in `default.toml` beside `plan.fnl`:

```
.
├── package.json
├── default.toml
└── plan.fnl
```

## Service bindings

The scaffolding adds no [service bindings][12factor_backing_services]. A plan declares its own with
`:binds`. A required binding to an [Elasticsearch][] service group:

```fennel
 :binds {:elasticsearch ["http-port" "transport-port"]}
```

Start the service with the binding:

```sh
doj start acmecorp/my_app --bind elasticsearch:es.my_app
```

## App type detection

The scaffolding does no framework detection.


[12factor_backing_services]: https://12factor.net/backing-services
[12factor_config]: https://12factor.net/config
[12factor_port]: https://12factor.net/port-binding
[12factor_processes]: https://12factor.net/processes
[Elasticsearch]: https://www.elastic.co/products/elasticsearch
[npm]: https://www.npmjs.com/
[`.nvmrc`]: https://github.com/nvm-sh/nvm#nvmrc
[`package.json`]: https://docs.npmjs.com/cli/configuring-npm/package-json
[`Procfile`]: https://devcenter.heroku.com/articles/procfile
[Yarn]: https://yarnpkg.com/
