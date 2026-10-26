;; bind, ported from its plan.sh.
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
{:name "bind"
 :origin "karate"
 :version "9.11.2"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["MPL-2.0"]
 :description "Versatile, Classic, Complete Name Server Software"
 :upstream_url "https://www.isc.org/downloads/bind/"
 :source {:url "https://ftp.isc.org/isc/bind9/9.11.2/bind-9.11.2.tar.gz" :sha256 "7f46ad8620f7c3b0ac375d7a5211b15677708fda84ce25d7aeb7222fe2e3c77a"}
 :deps ["karate/glibc" "karate/libxml2" "karate/openssl" "karate/zlib"]
 :build_deps ["karate/diffutils" "karate/file" "karate/gcc" "karate/make" "karate/perl"]
 :bin_dirs ["bin" "sbin"]
 :lib_dirs ["lib"]
 :include_dirs ["include"]
 :prepare (fn [b]
          (use-dependency-path b "/usr/bin/file" (b:path_for "file" "bin/file")))
 :build (fn [b]
          (b:run ["./configure" (.. "--prefix=" b.prefix) (.. "--with-libxml2=" (b:path_for "karate/libxml2")) (.. "--with-openssl=" (b:path_for "karate/openssl"))])
          (b:run ["make"]))
 :strip (fn [b]
          (b.default.strip b)
          ;; From do_end.
          )}
