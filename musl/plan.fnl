;; musl, ported from its plan.sh.
;; musl 1.2.6, the latest release on 2026-10-26.
{:name :musl
 :origin :karate
 :version :1.2.6
 :targets [:x86_64-linux]
 :maintainer "Strip Mall Karate Company"
 :license [:MIT]
 :description "musl is a new standard library to power a new generation of Linux-based devices. musl is lightweight, fast, simple, free, and strives to be correct in the sense of standards-conformance and safety."
 :upstream_url "https://www.musl-libc.org/"
 :source {:url "https://musl.libc.org/releases/musl-1.2.6.tar.gz"
          :sha256 :d585fd3b613c66151fc3249e8ed44f77020cb5e6c1e635a616d3f9f82460512a}
 :build_deps [:karate/coreutils
              :karate/diffutils
              :karate/gcc
              :karate/make
              :karate/patch
              :karate/sed]
 :bin_dirs [:bin]
 :lib_dirs [:lib]
 :include_dirs [:include]
 :prepare (fn [b]
            (var v-stack-size "")
            (set v-stack-size :2097152)
            (b:log (.. "Setting default stack size to '" v-stack-size
                       "' from default '131072'"))
            (let [text (b:read (b:join b.src :src/internal/pthread_impl.h))
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
                                    (string.gsub line
                                                 "#define DEFAULT_STACK_SIZE .*"
                                                 (.. "#define DEFAULT_STACK_SIZE "
                                                     (pick-values 1
                                                                  (: v-stack-size
                                                                     :gsub "%%"
                                                                     "%%%%")))
                                                 1))))
                (when (not deleted) (table.insert out line))
                (each [_ x (ipairs after)] (table.insert out x)))
              (b:write (b:join b.src :src/internal/pthread_impl.h)
                       (.. (table.concat out "\n")
                           (if (and ends (> (length out) 0))
                               "\n"
                               "")))))
 :build (fn [b]
          (b:run [:./configure
                  (.. :--prefix= b.prefix)
                  (.. :--syslibdir= b.prefix :/lib)])
          (b:run [:make :-j (tostring b.jobs)]))
 :install (fn [b]
            (b.default.install b)
            ;; gcc 16 links -latomic_asneeded unless -fno-link-libatomic, and musl's specs find
            ;; libraries only in musl's lib; musl has its atomics built in. Older gcc does not
            ;; know the option, so musl-gcc passes it only to a gcc that does.
            (let [wrapper (.. b.prefix :/bin/musl-gcc)
                  specs (.. b.prefix :/lib/musl-gcc.specs)]
              (b:write wrapper (.. "#!/bin/sh\n" "cc=\"${REALGCC:-gcc}\"\n" "if \"$cc\" -fno-link-libatomic -E -x c /dev/null >/dev/null 2>&1; then
" "  set -- \"$@\" -fno-link-libatomic
"
                                   "fi\n" "exec \"$cc\" \"$@\" -specs \"" specs
                                   "\"\n"))
              (b:chmod wrapper :755))
            (b:copy (b:join b.src :COPYRIGHT)
                    (.. b.prefix :/share/licenses/COPYRIGHT))
            (b:chmod (.. b.prefix :/share/licenses/COPYRIGHT) :0644))}
