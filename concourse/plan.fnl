;; concourse, ported from its plan.sh.
{:name :concourse
 :origin :karate
 :version :4.2.2
 :targets [:x86_64-linux]
 :maintainer "Strip Mall Karate Company"
 :license [:Apache-2.0]
 :description "CI that scales with your project"
 :upstream_url "https://concourse.ci"
 :source {:url "https://github.com/concourse/concourse/releases/download/v4.2.2/concourse_linux_amd64"
          :sha256 :5180903fee6a8fcdf8ba5bd34f270c5c467342f45534692af16f2951181e8749
          :filename :concourse_linux_amd64}
 :deps [:karate/glibc]
 :build_deps [:karate/patchelf]
 :bin_dirs [:bin]
 :unpack (fn [b]
           (if (b:exists b.name)
               (b:move (.. b.name :_linux_amd64)
                       (b:join b.name
                               (: (.. b.name :_linux_amd64) :match "[^/]+$")))
               (b:move (.. b.name :_linux_amd64) b.name))
           (b:chmod b.name :+x))
 :build (fn [_b]
          nil)
 :install (fn [b]
            (if (b:exists (.. b.prefix :/bin/ b.name))
                (b:copy (.. b.cache "/" b.name)
                        (b:join (.. b.prefix :/bin/ b.name)
                                (: (.. b.cache "/" b.name) :match "[^/]+$")))
                (b:copy (.. b.cache "/" b.name) (.. b.prefix :/bin/ b.name)))
            (b:run [:patchelf
                    :--interpreter
                    (.. (b:path_for :glibc) :/lib/ld-linux-x86-64.so.2)
                    (.. b.prefix :/bin/concourse)]))}
