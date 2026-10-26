;; openssl, ported from its plan.sh.
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
(fn v--common-prepare [b]
  (b.default.prepare b)
  (b:run ["patch" "-p1" "--backup"] {:stdin (let [text (b:read (.. b.plan_dir "/ca-dir.patch")) ends (= (text:sub -1) "\n") lines [] out []]
    (each [l (string.gmatch (if ends text (.. text "\n")) "(.-)\n")] (table.insert lines l))
    (each [n l (ipairs lines)]
      (var line l) (var deleted false) (local after [])
      (when (not deleted) (set line (pick-values 1 (string.gsub line "@prefix@" (pick-values 1 (: b.prefix :gsub "%%" "%%%%"))))))
      (when (not deleted) (set line (pick-values 1 (string.gsub line "@cacerts_prefix@" (pick-values 1 (: (b:path_for "cacerts") :gsub "%%" "%%%%"))))))
      (when (not deleted) (table.insert out line))
      (each [_ x (ipairs after)] (table.insert out x)))
    (.. (table.concat out "\n") (if (and ends (> (length out) 0)) "\n" "")))})
  ;; The plan linked coreutils' rm to /bin/rm, which OpenSSL's build scripts name.
  ;; Its comment held that the scripts must not change for the FIPS build; the
  ;; validated part is openssl-fips's canister, which this does not touch.
  (use-dependency-path b "/bin/rm" (b:path_for "karate/coreutils" "bin/rm"))
  )
{:name "openssl"
 :origin "karate"
 :version "1.0.2r"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["OpenSSL"]
 :description "OpenSSL is an open source project that provides a robust, commercial-grade, and full-featured toolkit for the Transport Layer Security (TLS) and Secure Sockets Layer (SSL) protocols. It is also a general-purpose cryptography library."
 :upstream_url "https://www.openssl.org"
 :source {:url "https://www.openssl.org/source/openssl-1.0.2r.tar.gz" :sha256 "ae51d08bba8a83958e894946f15303ff894d75c2b8bbd44a852b64e3fe11d0d6" :dirname "openssl-1.0.2r"}
 :deps ["karate/glibc" "karate/cacerts" "karate/openssl-fips"]
 :build_deps ["karate/coreutils" "karate/diffutils" "karate/patch" "karate/make" "karate/gcc" "karate/sed" "karate/grep" "karate/perl"]
 :bin_dirs ["bin"]
 :lib_dirs ["lib"]
 :include_dirs ["include"]
 :pconfig_dirs ["lib/pkgconfig"]
 :prepare (fn [b]
          (v--common-prepare b)
          (b:env "BUILD_CC" "gcc")
          (b:log (.. "Setting BUILD_CC=" (or (b:getenv "BUILD_CC") ""))))
 :build (fn [b]
          (var v-perl (.. (b:path_for "karate/perl") "/bin/perl"))
          (b:env "PERL" v-perl)
          (b:run [(.. (b:path_for "karate/perl") "/bin/perl") "./Configure" "no-idea" "no-mdc2" "no-rc5" "no-sslv2" "no-sslv3" "no-comp" "no-zlib" "shared" "disable-gost" (.. "--prefix=" b.prefix) "--openssldir=ssl" "linux-x86_64" (.. "--with-fipsdir=" (b:path_for "karate/openssl-fips")) "fips"])
          (b:run ["make" "CC=" "depend"])
          (b:run ["make" (.. "--jobs=" (tostring b.jobs)) (.. "CC=" (or (b:getenv "BUILD_CC") ""))]))
 :check (fn [b]
          (each [_ v-f (ipairs ["apps/CA.pl.in" "apps/CA.sh" "apps/openssl.cnf"])]
            (if (b:exists (if (= (: (.. v-f ".final") :sub 1 1) "/") (.. v-f ".final") (b:join b.src (.. v-f ".final"))))
            (b:copy (if (= (: v-f :sub 1 1) "/") v-f (b:join b.src v-f)) (b:join (if (= (: (.. v-f ".final") :sub 1 1) "/") (.. v-f ".final") (b:join b.src (.. v-f ".final"))) (: (if (= (: v-f :sub 1 1) "/") v-f (b:join b.src v-f)) :match "[^/]+$")))
            (b:copy (if (= (: v-f :sub 1 1) "/") v-f (b:join b.src v-f)) (if (= (: (.. v-f ".final") :sub 1 1) "/") (.. v-f ".final") (b:join b.src (.. v-f ".final"))))) (if (b:exists (if (= (: v-f :sub 1 1) "/") v-f (b:join b.src v-f)))
            (b:copy (if (= (: (.. v-f ".orig") :sub 1 1) "/") (.. v-f ".orig") (b:join b.src (.. v-f ".orig"))) (b:join (if (= (: v-f :sub 1 1) "/") v-f (b:join b.src v-f)) (: (if (= (: (.. v-f ".orig") :sub 1 1) "/") (.. v-f ".orig") (b:join b.src (.. v-f ".orig"))) :match "[^/]+$")))
            (b:copy (if (= (: (.. v-f ".orig") :sub 1 1) "/") (.. v-f ".orig") (b:join b.src (.. v-f ".orig"))) (if (= (: v-f :sub 1 1) "/") v-f (b:join b.src v-f)))))
          (b:run ["make" "test"])
          (each [_ v-f (ipairs ["apps/CA.pl.in" "apps/CA.sh" "apps/openssl.cnf"])]
            (if (b:exists (if (= (: v-f :sub 1 1) "/") v-f (b:join b.src v-f)))
            (b:copy (if (= (: (.. v-f ".final") :sub 1 1) "/") (.. v-f ".final") (b:join b.src (.. v-f ".final"))) (b:join (if (= (: v-f :sub 1 1) "/") v-f (b:join b.src v-f)) (: (if (= (: (.. v-f ".final") :sub 1 1) "/") (.. v-f ".final") (b:join b.src (.. v-f ".final"))) :match "[^/]+$")))
            (b:copy (if (= (: (.. v-f ".final") :sub 1 1) "/") (.. v-f ".final") (b:join b.src (.. v-f ".final"))) (if (= (: v-f :sub 1 1) "/") v-f (b:join b.src v-f))))))
 :install (fn [b]
          (b.default.install b)
          (b:remove (.. b.prefix "/ssl/misc"))
          (b:remove (.. b.prefix "/bin/c_rehash")))
 :strip (fn [b]
          (b.default.strip b)
          ;; From do_end.
          )}
