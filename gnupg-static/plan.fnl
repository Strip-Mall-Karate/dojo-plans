;; gnupg-static, ported from its plan.sh.
;; Built from the gnupg plan, with its own changes.
{:name "gnupg-static"
 :origin "karate"
 :version "1.4.20"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["gplv3+"]
 :source {:url "ftp://ftp.gnupg.org/gcrypt/gnupg/gnupg-1.4.20.tar.bz2" :sha256 "04988b1030fa28ddf961ca8ff6f0f8984e0cddcb1eb02859d5d8fe0fe237edcc" :dirname "gnupg-1.4.20"}
 :build_deps ["karate/glibc" "karate/zlib" "karate/bzip2" "karate/readline" "karate/coreutils" "karate/diffutils" "karate/patch" "karate/make" "karate/gcc" "karate/sed" "karate/findutils"]
 :bin_dirs ["bin"]
 :prepare (fn [b]
          (b:env "LDFLAGS" (.. "-static " (or (b:getenv "LDFLAGS") "")))
          (b:log (.. "Updating LDFLAGS=" (or (b:getenv "LDFLAGS") ""))))
 :build (fn [b]
          (b:run ["./configure" (.. "--prefix=" b.prefix) (.. "--sbindir=" b.prefix "/bin")])
          (b:run ["make"]))
 :check (fn [b]
          ;; find tests -type f | xargs sed: each file under tests, /bin/pwd made coreutils' pwd.
          (let [pwd (.. (b:path_for "coreutils") "/bin/pwd")]
            (each [_ f (ipairs (b:find (b:join b.src "tests") "*"))]
              (when (not (b:exists (b:join f ".")))
                (let [text (b:read f)
                      (fixed n) (: text :gsub "/bin/pwd" (pick-values 1 (: pwd :gsub "%%" "%%%%")))]
                  (when (> n 0) (b:write f fixed))))))
          (b:run ["make" "check"]))}
