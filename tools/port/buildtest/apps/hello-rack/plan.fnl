;; A small Rack app, built with scaffolding-ruby to test it.
{:name "hello-rack"
 :origin "test"
 :version "0.1.0"
 :targets ["x86_64-linux" "aarch64-linux"]
 :scaffolding {:package "karate/scaffolding-ruby" :settings {:env {:GREETING "hi"}}}}
