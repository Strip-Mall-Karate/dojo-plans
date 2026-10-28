;; m4, ported from its plan.sh.
;; m4 1.4.21, the latest release on 2026-10-26.
{:name :m4
 :origin :karate
 :version :1.4.21
 :targets [:x86_64-linux]
 :maintainer "Strip Mall Karate Company"
 :license [:gplv3]
 :description "GNU M4 is an implementation of the traditional Unix macro processor. It is mostly SVR4 compatible although it has some extensions (for example, handling more than 9 positional parameters to macros). GNU M4 also has built-in functions for including files, running shell commands, doing arithmetic, etc."
 :upstream_url "http://www.gnu.org/software/m4"
 :source {:url "https://ftp.gnu.org/gnu/m4/m4-1.4.21.tar.xz"
          :sha256 :f25c6ab51548a73a75558742fb031e0625d6485fe5f9155949d6486a2408ab66}
 :deps [:karate/glibc]
 :build_deps [:karate/coreutils
              :karate/diffutils
              :karate/patch
              :karate/make
              :karate/gcc
              :karate/binutils]
 :bin_dirs [:bin]
 :prepare (fn [b]
            (var v-dynamic-linker "")
            (b:env :CFLAGS
                   (.. (or (b:getenv :CFLAGS) "") " -B" (b:path_for :binutils)
                       :/bin/))
            (b:log (.. "Updating CFLAGS=" (or (b:getenv :CFLAGS) "")))
            (set v-dynamic-linker
                 (.. (b:path_for :glibc) :/lib/ld-linux-x86-64.so.2))
            (b:env :LDFLAGS
                   (.. (or (b:getenv :LDFLAGS) "") " -Wl,--dynamic-linker="
                       v-dynamic-linker))
            (b:log (.. "Updating LDFLAGS=" (or (b:getenv :LDFLAGS) ""))))
 :check (fn [b]
          (let [text (b:read (b:join b.src :build-aux/update-copyright))
                ends (= (text:sub -1) "\n")
                lines []
                out []]
            (each [l (string.gmatch (if ends text (.. text "\n")) "(.-)\n")]
              (table.insert lines l))
            (each [_n l (ipairs lines)]
              (var line l)
              (local deleted false)
              (local after [])
              (when (not deleted)
                (set line
                     (pick-values 1
                                  (string.gsub line "copyright{" "copyright\\{"
                                               1))))
              (when (not deleted) (table.insert out line))
              (each [_ x (ipairs after)] (table.insert out x)))
            (b:write (b:join b.src :build-aux/update-copyright)
                     (.. (table.concat out "\n")
                         (if (and ends (> (length out) 0))
                             "\n"
                             ""))))
          (b:run [:make :check]))}
