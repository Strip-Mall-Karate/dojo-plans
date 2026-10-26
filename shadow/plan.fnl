;; shadow, ported from its plan.sh.
{:name "shadow"
 :origin "karate"
 :version "4.6"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["bsd"]
 :description "Password and account management tool suite."
 :upstream_url "https://github.com/shadow-maint/shadow"
 :source {:url "https://github.com/shadow-maint/shadow/releases/download/4.6/shadow-4.6.tar.xz" :sha256 "0998c8d84242a231ab0acb7f8613927ff5bcff095f8aa6b79478893a03f05583"}
 :deps ["karate/glibc" "karate/attr" "karate/acl"]
 :build_deps ["karate/coreutils" "karate/diffutils" "karate/patch" "karate/make" "karate/gcc"]
 :bin_dirs ["bin"]
 :prepare (fn [b]
          (b:run ["patch" "-p1" "-i" (.. b.plan_dir "/dots-in-usernames.patch")])
          (let [text (b:read (b:join b.src "src/Makefile.in"))] (b:write (b:join b.src "src/Makefile.in") (pick-values 1 (string.gsub text "[^\n]+" (fn [l] (var line l) (set line (pick-values 1 (string.gsub line "groups$%(EXEEXT%) " "" 1))) line)))))
          (b:run ["find" "man" "-name" "Makefile.in" "-exec" "sed" "-i" "s/groups\\.1 / /" "{}" ";"])
          (let [text (b:read (b:join b.src "etc/login.defs"))] (b:write (b:join b.src "etc/login.defs") (pick-values 1 (string.gsub text "[^\n]+" (fn [l] (var line l) (set line (pick-values 1 (string.gsub line "#ENCRYPT_METHOD DES" "ENCRYPT_METHOD SHA512" 1))) line))))))
 :build (fn [b]
          (b:run ["./configure" (.. "--prefix=" b.prefix) "--with-acl" "--with-attr" "--with-group-name-max-length=32" "--without-selinux" "--without-libpam"])
          (b:run ["make"]))
 :check (fn [b]
          (b:run ["make" "check"]))
 :install (fn [b]
          (b.default.install b)
          (each [_ p (ipairs (b:glob (.. b.prefix "/sbin") "*"))] (b:move p (b:join (.. b.prefix "/bin/") (: p :match "[^/]+$"))))
          (b:remove (.. b.prefix "/sbin"))
          (b:copy (b:join b.src "COPYING") (.. b.prefix "/share/licenses/COPYING"))
          (b:chmod (.. b.prefix "/share/licenses/COPYING") "644"))}
