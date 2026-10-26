;; leproxy, ported from its plan.sh.
{:name "leproxy"
 :origin "karate"
 :version "20180113"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["MIT"]
 :description "https reverse proxy with automatic Letsencrypt usage for multiple hostnames/backends"
 :upstream_url "https://github.com/artyom/leproxy"
 :source {:url "https://github.com/artyom/leproxy/releases/download/20180113/leproxy-linux-amd64.tar.gz" :sha256 "c8a7ee698c8f4b4f828905d13978de30a79d6d394f992d8b1a170469c8e0d148"}
 :bin_dirs ["bin"]
 :build (fn [b]
          (b:move (.. b.cache "/leproxy") (b:join (.. b.cache "/" (.. b.name "-" b.version) "/") (: (.. b.cache "/leproxy") :match "[^/]+$"))))
 :install (fn [b]
          (b:copy (b:join b.src "leproxy") (.. b.prefix "/bin/leproxy"))
          (b:chmod (.. b.prefix "/bin/leproxy") "755"))}
