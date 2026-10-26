;; ruby24, ported from its plan.sh.
;; ruby24 2.4.10, the latest release on 2026-10-26: 2.4.5's source no longer downloads.
;; Built from the ruby plan, with its own changes.
{:name "ruby24"
 :origin "karate"
 :version "2.4.10"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["Ruby"]
 :description "A dynamic, open source programming language with a focus on simplicity and productivity. It has an elegant syntax that is natural to read and easy to write."
 :upstream_url "https://www.ruby-lang.org/en/"
 :source {:url "https://cache.ruby-lang.org/pub/ruby/2.4/ruby-2.4.10.tar.xz" :sha256 "d5668ed11544db034f70aec37d11e157538d639ed0d0a968e2f587191fc530df" :filename "ruby-2.4.10.tar.xz" :dirname "ruby-2.4.10"}
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
