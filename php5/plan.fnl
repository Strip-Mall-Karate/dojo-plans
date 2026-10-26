;; php5, ported from its plan.sh.
{:name "php5"
 :origin "karate"
 :version "5.6.39"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["PHP-3.01"]
 :description "PHP is a popular general-purpose scripting language that is especially suited to web development."
 :upstream_url "http://php.net/"
 :source {:url "https://php.net/get/php-5.6.39.tar.bz2/from/this/mirror" :sha256 "b3db2345f50c010b01fe041b4e0f66c5aa28eb325135136f153e18da01583ad5" :filename "php-5.6.39.tar.bz2" :dirname "php-5.6.39"}
 :deps ["karate/coreutils" "karate/curl" "karate/glibc" "karate/libxml2" "karate/openssl" "karate/readline" "karate/zlib"]
 :build_deps ["karate/bison2" "karate/gcc" "karate/make" "karate/re2c"]
 :bin_dirs ["bin" "sbin"]
 :lib_dirs ["lib"]
 :include_dirs ["include"]
 :interpreters ["bin/php"]
 :build (fn [b]
          (b:run ["./configure" (.. "--prefix=" b.prefix) "--enable-exif" "--enable-fpm" "--enable-mbstring" "--enable-opcache" (.. "--with-readline=" (b:path_for "readline")) (.. "--with-curl=" (b:path_for "curl")) (.. "--with-libxml-dir=" (b:path_for "libxml2")) (.. "--with-openssl=" (b:path_for "openssl")) "--with-xmlrpc" (.. "--with-zlib=" (b:path_for "zlib"))])
          (b:run ["make"]))
 :check (fn [b]
          (b:run ["make" "test"]))
 :install (fn [b]
          (b.default.install b)
          (if (b:exists (.. b.prefix "/etc/php-fpm.conf"))
            (b:move (.. b.prefix "/etc/php-fpm.conf.default") (b:join (.. b.prefix "/etc/php-fpm.conf") (: (.. b.prefix "/etc/php-fpm.conf.default") :match "[^/]+$")))
            (b:move (.. b.prefix "/etc/php-fpm.conf.default") (.. b.prefix "/etc/php-fpm.conf")))
          (let [text (b:read (.. b.prefix "/etc/php-fpm.conf"))] (b:write (.. b.prefix "/etc/php-fpm.conf") (pick-values 1 (string.gsub text "[^\n]+" (fn [l] (var line l) (set line (pick-values 1 (string.gsub line "nobody" "doj"))) line))))))}
