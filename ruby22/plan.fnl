;; ruby22, ported from its plan.sh.
;; Deprecated: true
;; Built from the ruby plan, with its own changes.
{:name "ruby22"
 :origin "karate"
 :version "2.2.10"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["Ruby"]
 :description "A dynamic, open source programming language with a focus on simplicity and productivity. It has an elegant syntax that is natural to read and easy to write."
 :upstream_url "https://www.ruby-lang.org/en/"
 :source {:url "https://cache.ruby-lang.org/pub/ruby/ruby-2.2.10.tar.gz" :sha256 "cd51019eb9d9c786d6cb178c37f6812d8a41d6914a1edaf0050c051c75d7c358" :dirname "ruby-2.2.10"}
 :deps ["karate/glibc/2.22" "karate/ncurses/6.0" "karate/zlib/1.2.8" "karate/openssl/1.0.2l" "karate/libyaml/0.1.6/20170514013335" "karate/libffi/3.2.1/20170514003538" "karate/readline/6.3.8"]
 :build_deps ["karate/coreutils" "karate/diffutils" "karate/patch" "karate/make" "karate/gcc/5.2.0" "karate/sed"]
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
