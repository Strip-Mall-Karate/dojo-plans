;; readline, ported from its plan.sh.
(var v-p "")
{:name "readline"
 :origin "karate"
 :version "7.0.3"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["GPL-3.0"]
 :description "The GNU Readline library provides a set of functions for use by applications that allow users to edit command lines as they are typed in."
 :upstream_url "http://tiswww.case.edu/php/chet/readline/rltop.html"
 :source {:url "http://ftp.gnu.org/gnu/readline/readline-7.0.tar.gz" :sha256 "750d437185286f40a369e1e4f4764eda932b9459b5ec9a731628393dd3d32334" :dirname "readline-7.0"}
 :deps ["karate/glibc" "karate/ncurses"]
 :build_deps ["karate/coreutils" "karate/diffutils" "karate/patch" "karate/make" "karate/gcc" "karate/bison" "karate/grep"]
 :lib_dirs ["lib"]
 :include_dirs ["include"]
 :download (fn [b]
          ;; From do_begin.
          ;; The values readline-patches.sh set, read when the plan was ported.
          (b.default.download b)
          (let [v--patch-filess ["http://ftp.gnu.org/gnu/readline/readline-7.0-patches/readline70-001" "http://ftp.gnu.org/gnu/readline/readline-7.0-patches/readline70-002" "http://ftp.gnu.org/gnu/readline/readline-7.0-patches/readline70-003"] v--patch-shasumss ["9ac1b3ac2ec7b1bf0709af047f2d7d2a34ccde353684e57c6b47ebca77d7a376" "8747c92c35d5db32eae99af66f17b384abaca961653e185677f9c9a571ed2d58" "9e43aa93378c7e9f7001d8174b1beb948deefa6799b6f581673f465b7d9d4780"]]
            (for [n 1 3]
              (set v-p (. v--patch-filess n)) (b:download v-p (. v--patch-shasumss n) (: (: v-p :gsub "/+$" "") :match "[^/]*$"))))
          (set v-p ""))
 :verify (fn [b]
          (b.default.verify b)
          (let [v--patch-filess ["http://ftp.gnu.org/gnu/readline/readline-7.0-patches/readline70-001" "http://ftp.gnu.org/gnu/readline/readline-7.0-patches/readline70-002" "http://ftp.gnu.org/gnu/readline/readline-7.0-patches/readline70-003"] v--patch-shasumss ["9ac1b3ac2ec7b1bf0709af047f2d7d2a34ccde353684e57c6b47ebca77d7a376" "8747c92c35d5db32eae99af66f17b384abaca961653e185677f9c9a571ed2d58" "9e43aa93378c7e9f7001d8174b1beb948deefa6799b6f581673f465b7d9d4780"]]
            (for [n 1 3]
              nil)))
 :prepare (fn [b]
          (b.default.prepare b)
          (each [_ v-p (ipairs ["http://ftp.gnu.org/gnu/readline/readline-7.0-patches/readline70-001" "http://ftp.gnu.org/gnu/readline/readline-7.0-patches/readline70-002" "http://ftp.gnu.org/gnu/readline/readline-7.0-patches/readline70-003"])]
            (b:log (.. "Applying patch " (: (: v-p :gsub "/+$" "") :match "[^/]*$"))) (b:run ["patch" "-p0" "-i" (.. b.cache "/" (: (: v-p :gsub "/+$" "") :match "[^/]*$"))]))
          (b:log "Applying patch link-against-ncurses.patch")
          (b:run ["patch" "-p1" "-i" (.. b.plan_dir "/../readline/link-against-ncurses.patch")]))
 :install (fn [b]
          (b.default.install b)
          (b:remove (.. b.prefix "/bin")))}
