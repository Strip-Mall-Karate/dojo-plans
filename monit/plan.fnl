;; monit, ported from its plan.sh.
{:name "monit"
 :origin "karate"
 :version "5.25.2"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["AGPL-3.0"]
 :description "Monit. Barking at daemons"
 :upstream_url "https://mmonit.com/monit"
 :source {:url "https://mmonit.com/monit/dist/monit-5.25.2.tar.gz" :sha256 "aa0ce6361d1155e43e30a86dcff00b2003d434f221c360981ced830275abc64a"}
 :deps ["karate/bash" "karate/glibc" "karate/openssl" "karate/zlib"]
 :build_deps ["karate/diffutils" "karate/gcc" "karate/make"]
 :bin_dirs ["bin"]
 :svc {:user "root" :group "root"}
 :exports {"port" "httpd.port"}
 :exposes ["port"]
 :build (fn [b]
          (b:run ["./configure" (.. "--prefix=" b.prefix) "--enable-optimized" "--without-pam" (.. "--with-ssl-incl-dir=" (b:path_for "karate/openssl") "/include")])
          (b:run ["make"]))}
