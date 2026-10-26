;; readline6, ported from its plan.sh.
;; Built from the readline plan, with its own changes.
(var v-p "")
{:name "readline6"
 :origin "karate"
 :version "6.3.8"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["GPL-3.0"]
 :description "The GNU Readline library provides a set of functions for use by applications that allow users to edit command lines as they are typed in."
 :upstream_url "http://tiswww.case.edu/php/chet/readline/rltop.html"
 :source {:url "http://ftp.gnu.org/gnu/readline/readline-6.3.tar.gz" :sha256 "56ba6071b9462f980c5a72ab0023893b65ba6debb4eeb475d7a563dc65cafd43" :dirname "readline-6.3"}
 :deps ["karate/glibc" "karate/ncurses"]
 :build_deps ["karate/coreutils" "karate/diffutils" "karate/patch" "karate/make" "karate/gcc" "karate/bison" "karate/grep"]
 :lib_dirs ["lib"]
 :include_dirs ["include"]
 :download (fn [b]
          ;; From do_begin.
          ;; The values readline-patches.sh set, read when the plan was ported.
          (b.default.download b)
          (let [v--patch-filess ["http://ftp.gnu.org/gnu/readline/readline-6.3-patches/readline63-001" "http://ftp.gnu.org/gnu/readline/readline-6.3-patches/readline63-002" "http://ftp.gnu.org/gnu/readline/readline-6.3-patches/readline63-003" "http://ftp.gnu.org/gnu/readline/readline-6.3-patches/readline63-004" "http://ftp.gnu.org/gnu/readline/readline-6.3-patches/readline63-005" "http://ftp.gnu.org/gnu/readline/readline-6.3-patches/readline63-006" "http://ftp.gnu.org/gnu/readline/readline-6.3-patches/readline63-007" "http://ftp.gnu.org/gnu/readline/readline-6.3-patches/readline63-008"] v--patch-shasumss ["1a79bbb6eaee750e0d6f7f3d059b30a45fc54e8e388a8e05e9c3ae598590146f" "39e304c7a526888f9e112e733848215736fb7b9d540729b9e31f3347b7a1e0a5" "ec41bdd8b00fd884e847708513df41d51b1243cecb680189e31b7173d01ca52f" "4547b906fb2570866c21887807de5dee19838a60a1afb66385b272155e4355cc" "877788f9228d1a9907a4bcfe3d6dd0439c08d728949458b41208d9bf9060274b" "5c237ab3c6c97c23cf52b2a118adc265b7fb411b57c93a5f7c221d50fafbe556" "4d79b5a2adec3c2e8114cbd3d63c1771f7c6cf64035368624903d257014f5bea" "3bc093cf526ceac23eb80256b0ec87fa1735540d659742107b6284d635c43787"]]
            (for [n 1 8]
              (set v-p (. v--patch-filess n)) (b:download v-p (. v--patch-shasumss n) (: (: v-p :gsub "/+$" "") :match "[^/]*$"))))
          (set v-p ""))
 :verify (fn [b]
          (b.default.verify b)
          (let [v--patch-filess ["http://ftp.gnu.org/gnu/readline/readline-6.3-patches/readline63-001" "http://ftp.gnu.org/gnu/readline/readline-6.3-patches/readline63-002" "http://ftp.gnu.org/gnu/readline/readline-6.3-patches/readline63-003" "http://ftp.gnu.org/gnu/readline/readline-6.3-patches/readline63-004" "http://ftp.gnu.org/gnu/readline/readline-6.3-patches/readline63-005" "http://ftp.gnu.org/gnu/readline/readline-6.3-patches/readline63-006" "http://ftp.gnu.org/gnu/readline/readline-6.3-patches/readline63-007" "http://ftp.gnu.org/gnu/readline/readline-6.3-patches/readline63-008"] v--patch-shasumss ["1a79bbb6eaee750e0d6f7f3d059b30a45fc54e8e388a8e05e9c3ae598590146f" "39e304c7a526888f9e112e733848215736fb7b9d540729b9e31f3347b7a1e0a5" "ec41bdd8b00fd884e847708513df41d51b1243cecb680189e31b7173d01ca52f" "4547b906fb2570866c21887807de5dee19838a60a1afb66385b272155e4355cc" "877788f9228d1a9907a4bcfe3d6dd0439c08d728949458b41208d9bf9060274b" "5c237ab3c6c97c23cf52b2a118adc265b7fb411b57c93a5f7c221d50fafbe556" "4d79b5a2adec3c2e8114cbd3d63c1771f7c6cf64035368624903d257014f5bea" "3bc093cf526ceac23eb80256b0ec87fa1735540d659742107b6284d635c43787"]]
            (for [n 1 8]
              nil)))
 :prepare (fn [b]
          (b.default.prepare b)
          (each [_ v-p (ipairs ["http://ftp.gnu.org/gnu/readline/readline-6.3-patches/readline63-001" "http://ftp.gnu.org/gnu/readline/readline-6.3-patches/readline63-002" "http://ftp.gnu.org/gnu/readline/readline-6.3-patches/readline63-003" "http://ftp.gnu.org/gnu/readline/readline-6.3-patches/readline63-004" "http://ftp.gnu.org/gnu/readline/readline-6.3-patches/readline63-005" "http://ftp.gnu.org/gnu/readline/readline-6.3-patches/readline63-006" "http://ftp.gnu.org/gnu/readline/readline-6.3-patches/readline63-007" "http://ftp.gnu.org/gnu/readline/readline-6.3-patches/readline63-008"])]
            (b:log (.. "Applying patch " (: (: v-p :gsub "/+$" "") :match "[^/]*$"))) (b:run ["patch" "-p0" "-i" (.. b.cache "/" (: (: v-p :gsub "/+$" "") :match "[^/]*$"))]))
          (b:log "Applying patch link-against-ncurses.patch")
          (b:run ["patch" "-p1" "-i" (.. b.plan_dir "/../readline/link-against-ncurses.patch")]))
 :install (fn [b]
          (b.default.install b)
          (b:remove (.. b.prefix "/bin")))}
