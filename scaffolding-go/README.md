# Go Scaffolding

Builds Go applications in a GOPATH: the source goes at `$GOPATH/src/<import path>`, where Go finds the
application's own packages and the ones it vendors. The GOPATH is the build's own, in the cache. The
scaffolding's package depends on Go, git, gcc and make, so a plan using it builds with them.

## From a source archive

The plan's source is the application's archive; the scaffolding unpacks it at its import path. For a
GitHub archive the import path is `github.com/<owner>/<repo>`:

```fennel
{:name "hello-go"
 :origin "myorigin"
 :version "0.1.0"
 :targets ["x86_64-linux"]
 :source {:url "https://github.com/myorg/hello-go/archive/v0.1.0.tar.gz"
          :sha256 "<the archive's SHA-256>"
          :filename "hello-go-v0.1.0.tar.gz"}
 :scaffolding "karate/scaffolding-go"}
```

Any other import path is a setting:

```fennel
 :scaffolding {:package "karate/scaffolding-go" :settings {:import_path "k8s.io/helm"}}
```

## From the plan's directory

A plan with no source is its own application: the scaffolding links the plan's directory at
`<base_path>/<name>` in the GOPATH. `base_path` is `localhost/user` unless the plan sets it:

```fennel
 :scaffolding {:package "karate/scaffolding-go" :settings {:base_path "github.com/myorg"}}
```

## Settings

| Setting | Meaning | Default |
| ------- | ------- | ------- |
| `import_path` | Where the source goes in the GOPATH | `github.com/<owner>/<repo>` of a GitHub archive, else `<base_path>/<name>` |
| `base_path` | The import path's start for a plan with no source | `localhost/user` |

## Phases

- `unpack`: the source at its import path (or the plan's directory linked there).
- `build`: `make` when the source has a Makefile, else `go build`.
- `install`: `go install`, then everything in `$GOPATH/bin` into the package's `bin`.

Every phase sets `GOPATH`, puts `$GOPATH/bin` first on `PATH`, and passes the build's `CFLAGS` and
`LDFLAGS` to cgo as `CGO_CFLAGS` and `CGO_LDFLAGS`. The scaffolding adds `bin` to the plan's
`bin_dirs`.

## For plans that build their own way

- `(b.scaffolding.env b)`: the environment above; call it first.
- `(b.scaffolding.gopath b)`: the GOPATH.
- `(b.scaffolding.pkg_path b)`: the source's directory in the GOPATH.
- `(b.scaffolding.import_path b)`: its import path.
- `(b.scaffolding.goarch b)`: Go's name for the target's architecture (`amd64`, `arm64`).

The source project's `scaffolding_go_build_deps` (more packages to `go get` at their newest commit) is
not carried over: a plan that needs another Go package fetches a pinned archive of it.
