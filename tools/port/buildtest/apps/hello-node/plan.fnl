;; A small Node app, built with scaffolding-node to test it.
{:name "hello-node"
 :origin "test"
 :version "0.1.0"
 :targets ["x86_64-linux" "aarch64-linux"]
 :scaffolding {:package "karate/scaffolding-node" :settings {:app_port 9000 :env {:GREETING "hi"}}}}
