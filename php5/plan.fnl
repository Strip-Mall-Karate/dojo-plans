;; php5, ported from its plan.sh.
;; php5 5.6.40, the latest release on 2026-10-26: 5.6.39's source no longer downloads.
{:name "php5"
 :origin "karate"
 :version "5.6.40"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["PHP-3.01"]
 :description "PHP is a popular general-purpose scripting language that is especially suited to web development."
 :upstream_url "http://php.net/"
 :source {:url "https://www.php.net/distributions/php-5.6.40.tar.xz" :sha256 "1369a51eee3995d7fbd1c5342e5cc917760e276d561595b6052b21ace2656d1c" :dirname "php-5.6.40"}
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
          (let [text (b:read (.. b.prefix "/etc/php-fpm.conf")) ends (= (text:sub -1) "\n") lines [] out []]
            (each [l (string.gmatch (if ends text (.. text "\n")) "(.-)\n")] (table.insert lines l))
            (each [n l (ipairs lines)]
              (var line l) (var deleted false) (local after [])
              (when (not deleted) (set line (pick-values 1 (string.gsub line "nobody" "doj"))))
              (when (not deleted) (table.insert out line))
              (each [_ x (ipairs after)] (table.insert out x)))
            (b:write (.. b.prefix "/etc/php-fpm.conf") (.. (table.concat out "\n") (if (and ends (> (length out) 0)) "\n" "")))))}
