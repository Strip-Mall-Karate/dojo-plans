;; readline, ported from its plan.sh.
;; readline 8.3.6, the latest release on 2026-10-26.
(var v-p "")
{:name :readline
 :origin :karate
 :version :8.3.6
 :targets [:x86_64-linux]
 :maintainer "Strip Mall Karate Company"
 :license [:GPL-3.0]
 :description "The GNU Readline library provides a set of functions for use by applications that allow users to edit command lines as they are typed in."
 :upstream_url "http://tiswww.case.edu/php/chet/readline/rltop.html"
 :source {:url "https://ftp.gnu.org/gnu/readline/readline-8.3.tar.gz"
          :sha256 :fe5383204467828cd495ee8d1d3c037a7eba1389c22bc6a041f627976f9061cc
          :dirname :readline-8.3}
 :deps [:karate/glibc :karate/ncurses]
 :build_deps [:karate/coreutils
              :karate/diffutils
              :karate/patch
              :karate/make
              :karate/gcc
              :karate/bison
              :karate/grep]
 :lib_dirs [:lib]
 :include_dirs [:include]
 :download (fn [b]
             ;; From do_begin.
             ;; The values readline-patches.sh set, read when the plan was ported.
             (b.default.download b)
             (let [v--patch-filess ["https://ftp.gnu.org/gnu/readline/readline-8.3-patches/readline83-001"
                                    "https://ftp.gnu.org/gnu/readline/readline-8.3-patches/readline83-002"
                                    "https://ftp.gnu.org/gnu/readline/readline-8.3-patches/readline83-003"
                                    "https://ftp.gnu.org/gnu/readline/readline-8.3-patches/readline83-004"
                                    "https://ftp.gnu.org/gnu/readline/readline-8.3-patches/readline83-005"
                                    "https://ftp.gnu.org/gnu/readline/readline-8.3-patches/readline83-006"]
                   v--patch-shasumss [:21f0a03106dbe697337cd25c70eb0edbaa2bdb6d595b45f83285cdd35bac84de
                                      :e27364396ba9f6debf7cbaaf1a669e2b2854241ae07f7eca74ca8a8ba0c97472
                                      :72dee13601ce38f6746eb15239999a7c56f8e1ff5eb1ec8153a1f213e4acdb29
                                      :1f189c4566aa35950964647b9ec3be1a821e42b86048129c63eb7f9d4d2f5a74
                                      :5481adbe161c9f6ba972c74db9e18c7aa351d3df3035cc4a673a1aa06247d1c6
                                      :4ebd261a608287796e171af0ea9af5a1e3122e46672accda2484b6698c47c1a4]]
               (for [n 1 6]
                 (set v-p (. v--patch-filess n))
                 (b:download v-p (. v--patch-shasumss n)
                             (: (: v-p :gsub "/+$" "") :match "[^/]*$"))))
             (set v-p ""))
 :verify (fn [b]
           (b.default.verify b)
           (let [v--patch-filess ["https://ftp.gnu.org/gnu/readline/readline-8.3-patches/readline83-001"
                                  "https://ftp.gnu.org/gnu/readline/readline-8.3-patches/readline83-002"
                                  "https://ftp.gnu.org/gnu/readline/readline-8.3-patches/readline83-003"
                                  "https://ftp.gnu.org/gnu/readline/readline-8.3-patches/readline83-004"
                                  "https://ftp.gnu.org/gnu/readline/readline-8.3-patches/readline83-005"
                                  "https://ftp.gnu.org/gnu/readline/readline-8.3-patches/readline83-006"]
                 v--patch-shasumss [:21f0a03106dbe697337cd25c70eb0edbaa2bdb6d595b45f83285cdd35bac84de
                                    :e27364396ba9f6debf7cbaaf1a669e2b2854241ae07f7eca74ca8a8ba0c97472
                                    :72dee13601ce38f6746eb15239999a7c56f8e1ff5eb1ec8153a1f213e4acdb29
                                    :1f189c4566aa35950964647b9ec3be1a821e42b86048129c63eb7f9d4d2f5a74
                                    :5481adbe161c9f6ba972c74db9e18c7aa351d3df3035cc4a673a1aa06247d1c6
                                    :4ebd261a608287796e171af0ea9af5a1e3122e46672accda2484b6698c47c1a4]]
             (for [n 1 6]
               nil)))
 :prepare (fn [b]
            (b.default.prepare b)
            (each [_ v-p (ipairs ["https://ftp.gnu.org/gnu/readline/readline-8.3-patches/readline83-001"
                                  "https://ftp.gnu.org/gnu/readline/readline-8.3-patches/readline83-002"
                                  "https://ftp.gnu.org/gnu/readline/readline-8.3-patches/readline83-003"
                                  "https://ftp.gnu.org/gnu/readline/readline-8.3-patches/readline83-004"
                                  "https://ftp.gnu.org/gnu/readline/readline-8.3-patches/readline83-005"
                                  "https://ftp.gnu.org/gnu/readline/readline-8.3-patches/readline83-006"])]
              (b:log (.. "Applying patch "
                         (: (: v-p :gsub "/+$" "") :match "[^/]*$")))
              (b:run [:patch
                      :-p0
                      :-i
                      (.. b.cache "/"
                          (: (: v-p :gsub "/+$" "") :match "[^/]*$"))]))
            (b:log "Applying patch link-against-ncurses.patch")
            (b:run [:patch
                    :-p1
                    :-i
                    (.. b.plan_dir :/../readline/link-against-ncurses.patch)]))
 :install (fn [b]
            (b.default.install b)
            (b:remove (.. b.prefix :/bin)))}
