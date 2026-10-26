# openssl

OpenSSL is an open source project that provides a robust, commercial-grade, and full-featured toolkit for the Transport Layer Security (TLS) and Secure Sockets Layer (SSL) protocols. It is also a general-purpose cryptography library.

## Maintainers

* Strip Mall Karate Company

## Type of Package

Binary package

## Usage

*TODO: Add instructions for usage*

## Base Plans

This section outlines a general playbook for maintainers who are building this plan.

As a base plan, this plan has extra considerations when merging PRs and building the plan. This base plan can safely be built without a core plans base refresh.

1. The following plans must be verified as successfully building, along with success of any automated tests, before merging any PRs:

```
dojo-plans/openssl
dojo-plans/openssl-musl/
dojo/components/doj/
dojo-plans/libarchive
dojo/components/sup
dojo-plans/curl
dojo-plans/postgresql
builder/components/builder-api
```

It is important to verify each of these packages because Dojo is a self-hosting system. In other words, `doj` is used to build `dojo-plans` and `dojo-plans` is used to build `doj`. We need to perform this extra level of verification to ensure that a change in a base plan does not prevent the ability to ship new packages.

1. Once the plan is merged, make a tracking issue on Github to document the work post merging the PR. This tracking issue should look something like: source project issue 2339

1. You must verify that all upstream plans can build successfully in `unstable`. Dojo Builder will kick off any builds as soon as the PR is merged. These builds should take around 5 hours to complete. You can monitor with this:

```
doj bldr job status -o core
```

```
☁ Determining status of job groups in karate origin

CREATED AT                        GROUP ID             STATUS       IDENT              TARGET
2019-03-05T19:10:56.463614+00:00  1195769776017088512  Queued       karate/openssl       x86_64-linux
2019-03-05T19:10:47.343695+00:00  1195769699504586752  Dispatching  karate/openssl       x86_64-windows
2019-03-05T19:10:47.285353+00:00  1195769699034816512  Dispatching  karate/openssl-musl  x86_64-linux
2019-03-05T16:52:42.427858+00:00  1195700200616992768  Complete     karate/cerebro       x86_64-linux
2019-03-05T15:50:28.109165+00:00  1195668874861944832  Complete     karate/doj-launcher  x86_64-linux
2019-03-05T15:50:28.078409+00:00  1195668874627055616  Complete     karate/doj-launcher  x86_64-windows
2019-03-05T15:25:23.177315+00:00  1195656250594066432  Complete     karate/nginx         x86_64-linux
2019-03-05T15:25:22.814329+00:00  1195656247548993536  Complete     karate/nginx         x86_64-windows
2019-03-05T15:17:21.338684+00:00  1195652208618766336  Complete     karate/packer        x86_64-linux
2019-03-05T15:17:21.318397+00:00  1195652208450985984  Complete     karate/packer        x86_64-windows
```

```
watch -n300 "doj bldr job status 1195769776017088512 -s | grep core/ | grep Failure"
```

1. Make a list of any failed builds and investigate any failures. At this point you will want to document issues with failures, or if the failures are transient, note them as such in the tracking issue.

1. At this point you can make a determination if any of the issues above are blocking promotion. You will want to block promotion if failed builds caused other core plans to become `Skipped`, but may also want to block based on other issues.

1. If you are not blocked from promoting, now you will want to promote the base plan package (in this case `openssl`).

1. Now you will want to interactively promote upstream packages. You can do this with:

```
doj bldr job promote <group_number> stable -o core -i
```

Where <number> is the job number.

Remove any packages with `doj` in the name. DO NOT PROMOTE ANYTHING WITH `doj` in the name!

1. Now you will need to do this for each job group. Note that there is currently a Builder API bug where Windows packages will return an error:

```
XXX
XXX Failed to promote job group: APIError(NotFound, "")
XXX
```

These will have to be promoted in the UI separately.

1. Finally, you will want to track and rebuild any packages that Failed during the build after you merged the PR. Rebuild any packages, regardless if they have known build issues or were transient failures.

1. Add any documentation that you learned during the process.

1. Close the tracking issue.
