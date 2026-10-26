;; iana-etc, ported from its plan.sh.
{:name "iana-etc"
 :origin "karate"
 :version "2.30"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["gplv3+"]
 :description "The iana-etc package provides the Unix/Linux /etc/services and /etc/protocols files."
 :upstream_url "http://sethwklein.net/iana-etc"
 :source {:url "http://sethwklein.net/iana-etc-2.30.tar.bz2" :sha256 "b9a6874fb20012836efef75452ef2acae624022d680feeb1994d73facba3f20d"}
 :build_deps ["karate/coreutils" "karate/make" "karate/gawk"]
 :build (fn [b]
          (b:run ["make"]))
 :install (fn [b]
          (b:run ["make" "install" (.. "PREFIX=" b.prefix)]))}
