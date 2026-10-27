;; perl, ported from its plan.sh.
;; perl 5.44.0, the latest release on 2026-10-26.
(var v-locincpth "")
(var v-loclibpth "")
{:name :perl
 :origin :karate
 :version :5.44.0
 :targets [:x86_64-linux]
 :maintainer "Strip Mall Karate Company"
 :license [:gpl :perlartistic]
 :description "Perl 5 is a highly capable, feature-rich programming language with over 29 years of development."
 :upstream_url "http://www.perl.org/"
 :source {:url "https://www.cpan.org/src/5.0/perl-5.44.0.tar.xz"
          :sha256 :505cf43912e9480495c344c70260452e32aa2a73c546a026b3f100053b23ce91}
 :deps [:karate/glibc
        :karate/libxcrypt
        :karate/zlib
        :karate/bzip2
        :karate/gdbm
        :karate/db
        :karate/coreutils
        :karate/less]
 :build_deps [:karate/coreutils
              :karate/diffutils
              :karate/patch
              :karate/make
              :karate/gcc
              :karate/procps-ng
              :karate/inetutils
              :karate/iana-etc]
 :bin_dirs [:bin]
 :lib_dirs [:lib]
 :interpreters [:bin/perl]
 :prepare (fn [b]
            (b.default.prepare b)
            (b:run [:patch :-p1 :-i (.. b.plan_dir :/no-sys-dirs.patch)])
            (let [text (b:read (b:join b.src :dist/PathTools/Cwd.pm))
                  ends (= (text:sub -1) "\n")
                  lines []
                  out []]
              (each [l (string.gmatch (if ends text (.. text "\n")) "(.-)\n")]
                (table.insert lines l))
              (each [n l (ipairs lines)]
                (var line l)
                (var deleted false)
                (local after [])
                (when (not deleted)
                  (set line
                       (pick-values 1
                                    (string.gsub line "'/bin/pwd'"
                                                 (.. "'"
                                                     (pick-values 1
                                                                  (: (b:path_for :coreutils)
                                                                     :gsub "%%"
                                                                     "%%%%"))
                                                     "/bin/pwd'")))))
                (when (not deleted) (table.insert out line))
                (each [_ x (ipairs after)] (table.insert out x)))
              (b:write (b:join b.src :dist/PathTools/Cwd.pm)
                       (.. (table.concat out "\n")
                           (if (and ends (> (length out) 0))
                               "\n"
                               ""))))
            (set v-locincpth "")
            (each [_ v-i (ipairs [(or (b:getenv :CFLAGS) "")])]
              (when (string.find v-i "^%-I/")
                (set v-locincpth
                     (.. v-locincpth " "
                         (pick-values 1 (string.gsub v-i "^%-I" "" 1))))))
            (set v-loclibpth "")
            (each [_ v-i (ipairs [(or (b:getenv :LDFLAGS) "")])]
              (when (string.find v-i "^%-L/")
                (set v-loclibpth
                     (.. v-loclibpth " "
                         (pick-values 1 (string.gsub v-i "^%-L" "" 1))))))
            ;; Only the build directory, where libperl is before it is installed: perl's programs
            ;; find their dependencies by RUNPATH, and a glibc here is loaded by every program the
            ;; build runs, the host's sh included, which a first build cannot have match.
            (b:env :LD_LIBRARY_PATH (b:capture [:pwd]))
            (b:log (.. "Setting LD_LIBRARY_PATH="
                       (or (b:getenv :LD_LIBRARY_PATH) ""))))
 :build (fn [b]
          (b:env :BUILD_ZLIB :False)
          (b:env :BUILD_BZIP2 :0)
          ;; Where zlib's and bzip2's headers and libraries are: Compress-Raw-Zlib and -Bzip2
          ;; read these, and perl 5.44 no longer passes its include paths to them.
          (b:env :ZLIB_INCLUDE (.. (b:path_for :zlib) :/include))
          (b:env :ZLIB_LIB (.. (b:path_for :zlib) :/lib))
          (b:env :BZIP2_INCLUDE (.. (b:path_for :bzip2) :/include))
          (b:env :BZIP2_LIB (.. (b:path_for :bzip2) :/lib))
          (b:run [:sh
                  :Configure
                  :-de
                  (.. :-Dprefix= b.prefix)
                  (.. :-Dman1dir= b.prefix :/share/man/man1)
                  (.. :-Dman3dir= b.prefix :/share/man/man3)
                  (.. :-Dlocincpth= v-locincpth)
                  (.. :-Dloclibpth= v-loclibpth)
                  (.. :-Dpager= (b:path_for :less) "/bin/less -isR")
                  :-Dinstallstyle=lib/perl5
                  :-Uinstallusrbinperl
                  :-Duseshrplib
                  :-Dusethreads
                  :-Dinc_version_list=none
                  (.. "-Dlddlflags=-shared " (or (b:getenv :LDFLAGS) ""))
                  (.. :-Dldflags= (or (b:getenv :LDFLAGS) ""))])
          (b:run [:make (.. :-j (tostring b.jobs))])
          (b:unsetenv :BUILD_ZLIB)
          (b:unsetenv :BUILD_BZIP2))
 :check (fn [b]
          (var v-clean-protocols "")
          (var v-clean-services "")
          ;; The plan copied iana-etc's services file to /etc/services for the tests when it
          ;; was missing. A Dojo build writes nothing outside itself; the tests need a
          ;; services file where the build runs.
          ;; The plan copied iana-etc's protocols file to /etc/protocols for the tests when
          ;; it was missing. A Dojo build writes nothing outside itself; the tests need a
          ;; protocols file where the build runs.
          (b:run [:make :test]))}
