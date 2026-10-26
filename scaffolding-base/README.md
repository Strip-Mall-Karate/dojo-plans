# scaffolding-base

The scaffolding for scaffoldings. A scaffolding is a package shipping `lib/scaffolding.fnl`, the module
Dojo loads for the plans that name it. A plan using scaffolding-base has no source and nothing to build;
its package is its own `lib/scaffolding.fnl`:

```fennel
{:name "scaffolding-mylang"
 :origin "myorigin"
 :version "0.1.0"
 :targets ["x86_64-linux" "aarch64-linux"]
 :deps ["myorigin/mylang"]
 :scaffolding "karate/scaffolding-base"}
```

The scaffolding package's `deps` become build dependencies of every plan using it.

## Maintainers

* Strip Mall Karate Company
