# Use Node Scaffolding for your app

## Dojo setup

Install Dojo for development as the Getting Started with Dojo tutorial describes. That leaves you with a
`doj` program and an origin key for signing the packages you build.

## Create a plan that uses the Node Scaffolding

In the root of your app, beside `package.json`, create `plan.fnl`:

```fennel
{:name "MY_APP"
 :origin "MY_ORIGIN"
 :version "MY_VERSION"
 :targets ["x86_64-linux"]
 :scaffolding "karate/scaffolding-node"}
```

Replace:

- `MY_APP` with your app's name, which becomes the package's name
- `MY_ORIGIN` with the origin you chose during setup
- `MY_VERSION` with your app's version

The plan has no `:source`. The directory holding `plan.fnl` is the app. A plan can also live in a `dojo/`
subdirectory, as `dojo/plan.fnl`, and the directory above it is then the app.

The app needs a `web` process: a `web` line in a `Procfile`, or `scripts.start` in `package.json`. The
[reference](reference.md#process-bins) has the details.

Commit the plan with your app:

```sh
git add plan.fnl
git commit
```

## Build your app package

There are two ways to build a package:

1. `doj studio enter`
2. `doj pkg build`

### Build interactively with studio enter

For a quick feedback loop while you get the build working, enter a Studio from the root of your app:

```sh
doj studio enter
```

The shell starts in `/src`, where your app is mounted. Build it with:

```sh
build
```

Start a built package in the Studio with `doj start MY_ORIGIN/MY_APP`. Your app may need options such as
service bindings. Built packages go to `./results/`, inside and outside the Studio. Leave with `exit`.

### Build from scratch with pkg build

`doj pkg build` runs the same build in a Studio created fresh each time, so nothing left from an earlier
build affects it. Use it on CI. From the root of your app:

```sh
doj pkg build
```
