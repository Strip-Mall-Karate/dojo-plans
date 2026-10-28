;; libghthash, ported from its plan.sh.
{:name :libghthash
 :origin :karate
 :version :0.6.2
 :targets [:x86_64-linux]
 :maintainer "Strip Mall Karate Company"
 :license [:LGPL-2.0]
 :description "Generic Hash Table which is meant to be easy to extend, portable, clear in its code and easy to use."
 :upstream_url "https://github.com/SimonKagstrom/libghthash"
 :source {:url "https://github.com/SimonKagstrom/libghthash/archive/v0.6.2.tar.gz"
          :sha256 :e7e5f77df3e2a9152e0805f279ac048af9e572b83e60d29257cc754f8f9c22d6}
 :deps [:karate/glibc]
 :build_deps [:karate/autoconf
              :karate/automake
              :karate/gcc
              :karate/libtool
              :karate/make]
 :lib_dirs [:lib]
 :include_dirs [:include]
 :build (fn [b]
          (let [text (b:read (b:join b.src :configure.in))
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
                                  (string.gsub line "AM_PROG_LIBTOOL%(%)"
                                               :LT_INIT))))
              (when (not deleted) (table.insert out line))
              (each [_ x (ipairs after)] (table.insert out x)))
            (b:write (b:join b.src :configure.in)
                     (.. (table.concat out "\n")
                         (if (and ends (> (length out) 0))
                             "\n"
                             ""))))
          (b:write (b:join b.src :configure.in)
                   (.. (if (b:exists (b:join b.src :configure.in))
                           (b:read (b:join b.src :configure.in))
                           "") "AC_CONFIG_MACRO_DIRS([m4])
"))
          (b:run [:libtoolize])
          (b:run [:aclocal :-I :m4])
          (b:run [:autoconf])
          (b:run [:automake :--add-missing])
          (b.default.build b))}
