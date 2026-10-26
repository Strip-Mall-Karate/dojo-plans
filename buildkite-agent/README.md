# buildkite-agent

The buildkite-agent is a small, reliable, and cross-platform build runner that makes it easy to run automated builds on your own infrastructure. It’s main responsibilities are polling [buildkite.com](https://buildkite.com) for work, running build jobs, reporting back the status code and output log of the job, and uploading the job's artifacts.

Full documentation is available at [buildkite.com/docs/agent](https://buildkite.com/docs/agent).

## Maintainers

* Strip Mall Karate Company

## Type of Package

Binary package

> While the `buildkite-agent` can run as a service, this package does not support that functionality yet.

## Usage

```
doj pkg install karate/buildkite-agent
doj pkg exec karate/buildkite-agent buildkite-agent
```
