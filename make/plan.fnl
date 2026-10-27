;; make, ported from its plan.sh.
;; make 4.4.1, the latest release on 2026-10-26.
{:name :make
 :origin :karate
 :version :4.4.1
 :targets [:x86_64-linux]
 :maintainer "Strip Mall Karate Company"
 :license [:GPL-3.0]
 :description "Make is a tool which controls the generation of executables and other non-source files of a program from the program's source files."
 :upstream_url "https://www.gnu.org/software/make/"
 :source {:url "https://ftp.gnu.org/gnu/make/make-4.4.1.tar.gz"
          :sha256 :dd16fb1d67bfab79a72f5e8390735c49e3e8e70b4945a15ab1f81ddb78658fb3}
 :deps [:karate/glibc]
 :build_deps [:karate/coreutils
              :karate/diffutils
              :karate/patch
              :karate/make
              :karate/gcc
              :karate/bash
              :karate/gettext
              :karate/gzip
              :karate/perl
              :karate/binutils]
 :bin_dirs [:bin]
 :include_dirs [:include]
 :prepare (fn [b]
            (b.default.prepare b)
            (b:run [:patch :-p1 :-i (.. b.plan_dir :/no-sys-dirs.patch)]))
 :check (fn [b]
          (b:mkdir (b:join b.src :wrappers))
          (b:write (b:join b.src :wrappers/ar) (.. "#!" (b:path_for :bash)
                                                   "/bin/sh\nexec "
                                                   (b:path_for :binutils) "/bin/ar U$@
"))
          (b:chmod (b:join b.src :wrappers/ar) :0744)
          (b:run [:env
                  (.. :PATH= (b:capture [:pwd]) "/wrappers:"
                      (or (b:getenv :PATH) ""))
                  :PERL_USE_UNSAFE_INC=1
                  :make
                  :check]))}
