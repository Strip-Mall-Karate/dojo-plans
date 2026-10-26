;; ruby, ported from its plan.sh.
;; ruby 4.0.9, the latest release on 2026-10-26: 2.5.5's source no longer downloads.
{:name "ruby"
 :origin "karate"
 :version "4.0.9"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["Ruby"]
 :description "A dynamic, open source programming language with a focus on simplicity and productivity. It has an elegant syntax that is natural to read and easy to write."
 :upstream_url "https://www.ruby-lang.org/en/"
 :source {:url "https://cache.ruby-lang.org/pub/ruby/4.0/ruby-4.0.9.tar.xz" :sha256 "a8057adb39f51ad6dc3106237504c93dd792bb515837b4fe7817ae21ed7e51f4"}
 :deps ["karate/glibc" "karate/ncurses" "karate/zlib" "karate/openssl" "karate/libyaml" "karate/libffi" "karate/readline"]
 :build_deps ["karate/coreutils" "karate/diffutils" "karate/patch" "karate/make" "karate/gcc" "karate/sed"]
 :bin_dirs ["bin"]
 :lib_dirs ["lib"]
 :include_dirs ["include"]
 :interpreters ["bin/ruby"]
 :prepare (fn [b]
          (b:env "CFLAGS" (.. (or (b:getenv "CFLAGS") "") " -O3 -g -pipe"))
          (b:log (.. "Setting CFLAGS='" (or (b:getenv "CFLAGS") "") "'")))
 :build (fn [b]
          (b:run ["./configure" (.. "--prefix=" b.prefix) "--enable-shared" "--disable-install-doc" (.. "--with-openssl-dir=" (b:path_for "karate/openssl")) (.. "--with-libyaml-dir=" (b:path_for "karate/libyaml"))])
          (b:run ["make"]))
 :check (fn [b]
          (b:run ["make" "test"]))
 :install (fn [b]
          (b.default.install b)
          (b:run ["gem" "update" "--system" "2.7.8" "--no-document"])
          (b:run ["gem" "install" "rb-readline" "--no-document"]))}
