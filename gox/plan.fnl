;; gox, ported from its plan.sh.
{:name "gox"
 :origin "karate"
 :version "0.4.0"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["MPL-2.0"]
 :description "A dead simple, no frills Go cross compile tool"
 :upstream_url "https://github.com/mitchellh/gox"
 :source {:url "https://github.com/mitchellh/gox/archive/v0.4.0.tar.gz" :sha256 "2df7439e9901877685ff4e6377de863c3c2ec4cde43d0ca631ff65d1b64774ad"}
 :build_deps ["karate/git" "karate/go"]
 :bin_dirs ["bin"]
 :prepare (fn [b]
          (b:env "GOPATH" b.cache))
 :build (fn [b]
          (b:run ["go" "get" "github.com/mitchellh/iochan"])
          (b:run ["go" "get" "github.com/hashicorp/go-version"])
          (b:run ["go" "build" "-o" (.. b.prefix "/bin/gox")]))
 :install (fn [b]
          nil)}
