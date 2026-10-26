# Dojo Plans

The plans that build [Dojo](https://github.com/StripMallKarateCompany/dojo)'s packages in the `karate`
origin: one directory per package, with the plan and whatever the package carries beside it (hooks,
configuration templates, `default.toml`, tests). Builder is `https://bldr.karate.company`.

The tree starts from the source project's package plans as of 10 April 2019, the same point Dojo
itself forked from, with their history. Plans are written in Fennel, one `plan.fnl` per package (see
Dojo's `components/plan`); the bash plans they replace are being ported. Plans build for Linux
only.

`base-plans.txt` lists the base toolchain in the order it is built. `.bldr.toml` tells Builder where
each plan lives.

[swamp](swamp/README.md) builds a plan and everything it depends on, in dependency order, with
`doj-plan-build`.

## License

New work in Dojo Plans is MIT licensed: see [LICENSE](LICENSE). The plans and files inherited from
the source project, and the plans ported from them, stay under the Apache License 2.0 with Dojo's
changes to them: see [LICENSE-APACHE](LICENSE-APACHE) and [NOTICE](NOTICE).

Copyright (c) 2016 Chef Software Inc. and/or applicable contributors
Copyright (c) 2026 Strip Mall Karate Company
