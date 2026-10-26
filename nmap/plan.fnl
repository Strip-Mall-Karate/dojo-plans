;; nmap, ported from its plan.sh.
(fn use-dependency-path [b path replacement]
  ;; The source project's studio linked a dependency's tool to `path` for the
  ;; build. A Dojo build writes nothing outside itself, so the build's scripts
  ;; name the dependency's tool instead.
  (each [_ f (ipairs (b:find b.src "*"))]
    (let [name (: f :match "[^/]+$")]
      (when (and (or (: name :match "^configure") (: name :match "^Makefile") (: name :match "^ltmain")
                     (: name :match "%.in$") (: name :match "%.am$") (: name :match "%.ac$")
                     (: name :match "%.m4$") (: name :match "%.mk$") (: name :match "%.sh$")
                     (: name :match "%.pl$") (: name :match "%.py$"))
                 (not (b:exists (b:join f "."))))
        (let [text (b:read f)
              escaped (pick-values 1 (: path :gsub "[%^%$%(%)%%%.%[%]%*%+%-%?]" "%%%0"))
              (fixed n) (: text :gsub escaped (pick-values 1 (: replacement :gsub "%%" "%%%%")))]
          (when (> n 0) (b:write f fixed)))))))
{:name "nmap"
 :origin "karate"
 :version "7.70"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["GPL-2.0"]
 :description "nmap is a free security scanner for network exploration and security audits"
 :upstream_url "https://nmap.org/"
 :source {:url "https://nmap.org/dist/nmap-7.70.tar.bz2" :sha256 "847b068955f792f4cc247593aca6dc3dc4aae12976169873247488de147a6e18"}
 :deps ["karate/glibc" "karate/gcc-libs" "karate/libpcap" "karate/libssh2" "karate/openssl" "karate/pcre" "karate/zlib"]
 :build_deps ["karate/bzip2" "karate/coreutils" "karate/diffutils" "karate/file" "karate/gcc" "karate/inetutils" "karate/lua" "karate/make" "karate/openssh" "karate/pkg-config" "karate/readline" "karate/which"]
 :bin_dirs ["bin"]
 :prepare (fn [b]
          (b:env "CFLAGS" (.. (or (b:getenv "CFLAGS") "") " -O2 -Wcpp"))
          (b:env "CXXFLAGS" (.. (or (b:getenv "CXXFLAGS") "") " -O2 -Wcpp"))
          (use-dependency-path b "/usr/bin/file" (b:path_for "file" "bin/file")))
 :build (fn [b]
          (b:run ["./configure" (.. "--prefix=" b.prefix) "--without-zenmap" "--with-libdnet=included" "--with-liblinear=included" (.. "--with-liblua=" (b:path_for "karate/lua")) (.. "--with-libpcre=" (b:path_for "karate/pcre")) (.. "--with-libssh2=" (b:path_for "karate/libssh2")) (.. "--with-libz=" (b:path_for "karate/zlib"))])
          (b:run ["make"]))
 :check (fn [b]
          (b:run ["make" "check"]))
 :strip (fn [b]
          (b.default.strip b)
          ;; From do_end.
          )}
