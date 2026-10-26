;; gnutls, ported from its plan.sh.
;; gnutls 3.8.13, the latest release on 2026-10-26: 3.6.5's source no longer downloads.
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
{:name "gnutls"
 :origin "karate"
 :version "3.8.13"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["LGPL-2.1-or-later"]
 :description "GnuTLS is a secure communications library implementing the SSL, TLS and DTLS protocols and technologies around them"
 :upstream_url "https://www.gnutls.org/"
 :source {:url "https://www.gnupg.org/ftp/gcrypt/gnutls/v3.8/gnutls-3.8.13.tar.xz" :sha256 "ffed8ec1bf09c2426d4f14aae377de4753b53e537d685e604e99a8b16ca9c97e"}
 :deps ["karate/glibc" "karate/gmp" "karate/guile" "karate/libiconv" "karate/libidn2" "karate/libseccomp" "karate/libtasn1" "karate/libunistring" "karate/nettle" "karate/p11-kit" "karate/zlib"]
 :build_deps ["karate/autogen" "karate/bison" "karate/diffutils" "karate/file" "karate/gettext" "karate/gcc" "karate/iproute2" "karate/make" "karate/pkg-config" "karate/which"]
 :lib_dirs ["lib"]
 :include_dirs ["include"]
 :pconfig_dirs ["lib/pkgconfig"]
 :prepare (fn [b]
          (use-dependency-path b "/usr/bin/file" (b:path_for "file" "bin/file")))
 :build (fn [b]
          (b:run ["./configure" (.. "--prefix=" b.prefix) (.. "--with-libseccomp-prefix=" (b:path_for "karate/libseccomp")) (.. "--with-libiconv-prefix=" (b:path_for "karate/libiconv")) (.. "--with-libunistring-prefix=" (b:path_for "karate/libunistring")) "--disable-valgrind-tests"])
          (b:run ["make" (.. "-j" (tostring b.jobs))]))
 :check (fn [b]
          (b:run ["make" "check"]))
 :strip (fn [b]
          (b.default.strip b)
          ;; From do_end.
          )}
