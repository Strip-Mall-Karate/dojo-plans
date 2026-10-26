;; wget, ported from its plan.sh.
(fn v--wget-common-prepare [b]
  (each [v-f (: (b:capture ["grep" "-lr" "/usr/bin/env" "."]) :gmatch "[^
  ]+")]
    (let [text (b:read (if (= (: v-f :sub 1 1) "/") v-f (b:join b.src v-f))) ends (= (text:sub -1) "\n") lines [] out []]
    (each [l (string.gmatch (if ends text (.. text "\n")) "(.-)\n")] (table.insert lines l))
    (each [n l (ipairs lines)]
      (var line l) (var deleted false) (local after [])
      (when (not deleted) (set line (pick-values 1 (string.gsub line "/usr/bin/env" (.. (pick-values 1 (: (b:path_for "coreutils") :gsub "%%" "%%%%")) "/bin/env")))))
      (when (not deleted) (table.insert out line))
      (each [_ x (ipairs after)] (table.insert out x)))
    (b:write (if (= (: v-f :sub 1 1) "/") v-f (b:join b.src v-f)) (.. (table.concat out "\n") (if (and ends (> (length out) 0)) "\n" ""))))))
{:name "wget"
 :origin "karate"
 :version "1.19.5"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["GPL-3.0+"]
 :description "GNU Wget is a free software package for retrieving files using HTTP, HTTPS, FTP and FTPS the most widely-used Internet protocols."
 :upstream_url "https://www.gnu.org/software/wget/"
 :source {:url "https://ftp.gnu.org/gnu/wget/wget-1.19.5.tar.gz" :sha256 "b39212abe1a73f2b28f4c6cb223c738559caac91d6e416a6d91d4b9d55c9faee"}
 :deps ["karate/cacerts" "karate/glibc" "karate/openssl" "karate/pcre" "karate/zlib"]
 :build_deps ["karate/coreutils" "karate/diffutils" "karate/flex" "karate/gcc" "karate/gettext" "karate/grep" "karate/make" "karate/patch" "karate/perl" "karate/pkg-config" "karate/sed"]
 :bin_dirs ["bin"]
 :prepare (fn [b]
          (v--wget-common-prepare b))
 :build (fn [b]
          (b:run ["./configure" (.. "--prefix=" b.prefix) "--with-ssl=openssl" "--without-libuuid"])
          (b:run ["make"]))
 :check (fn [b]
          (b:run ["cpan" "HTTP:Daemon"] {:env {"PERL_MM_USE_DEFAULT" "1"}})
          (b:run ["make" "check"]))
 :install (fn [b]
          (var v-ca-certificate "")
          (b.default.install b)
          (b:write (.. b.prefix "/etc/wgetrc") (.. (if (b:exists (.. b.prefix "/etc/wgetrc")) (b:read (.. b.prefix "/etc/wgetrc")) "") (.. "\n# Default root CA certs location\nca_certificate=" (b:path_for "karate/cacerts") "/ssl/certs/cacert.pem\n"))))}
