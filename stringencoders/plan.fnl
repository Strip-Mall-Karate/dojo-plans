;; stringencoders, ported from its plan.sh.
{:name :stringencoders
 :origin :karate
 :version :3.10.3
 :targets [:x86_64-linux]
 :maintainer "Strip Mall Karate Company"
 :license [:BSD-3-Clause :Apache-2.0]
 :description "Fast c-string transformations"
 :upstream_url "https://github.com/client9/stringencoders"
 :source {:url "https://github.com/client9/stringencoders/archive/e0d6a9b294c9ab619c510c1f6317bb9ec7194d77.tar.gz"
          :sha256 :6d5bc3eeea1f2a73d35d558746bbb35916f1a159a2b52ed78e9c20a29050607e
          :dirname :stringencoders-e0d6a9b294c9ab619c510c1f6317bb9ec7194d77}
 :deps [:karate/glibc]
 :build_deps [:karate/gcc
              :karate/make
              :karate/perl
              :karate/patch
              :karate/file
              :karate/diffutils]
 :bin_dirs [:bin]
 :lib_dirs [:lib]
 :include_dirs [:include]
 :prepare (fn [b]
            (b:run [:patch
                    :-p1
                    :-i
                    (.. b.plan_dir :/remove-path-for-file.patch)])
            (b:run [:patch
                    :-p1
                    :-i
                    (.. b.plan_dir :/unused-variable-in-tests.patch)]))
 :check (fn [b]
          (b:run [:make :test]
                 {:env {:LD_LIBRARY_PATH (.. (b:path_for :karate/gcc-libs)
                                             :/lib)}}))}
