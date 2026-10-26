;; nss, ported from its plan.sh.
{:name "nss"
 :origin "karate"
 :version "3.40.1"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["MPL-2.0"]
 :description "Network Security Services"
 :upstream_url "https://developer.mozilla.org/en-US/docs/Mozilla/Projects/NSS"
 :source {:url "https://ftp.mozilla.org/pub/mozilla.org/security/nss/releases/NSS_3_40_1_RTM/src/nss-3.40.1.tar.gz" :sha256 "5e0e6bae2a79c86e506684955d736bfe875ec5a8e95ed3e4ba0852d1aec2c8f1"}
 :deps ["karate/glibc" "karate/nspr" "karate/sqlite" "karate/zlib" "karate/gcc-libs"]
 :build_deps ["karate/gcc" "karate/make" "karate/perl"]
 :bin_dirs ["bin"]
 :lib_dirs ["lib"]
 :include_dirs ["include/nss"]
 :prepare (fn [b]
          (let [text (b:read (b:join b.src "nss/coreconf/rules.mk")) ends (= (text:sub -1) "\n") lines [] out []]
            (each [l (string.gmatch (if ends text (.. text "\n")) "(.-)\n")] (table.insert lines l))
            (each [n l (ipairs lines)]
              (var line l) (var deleted false) (local after [])
              (when (not deleted) (when (string.find line "$%(MKSHLIB%) %-o") (set line (pick-values 1 (string.gsub line "$" " $(LDFLAGS)" 1)))))
              (when (not deleted) (table.insert out line))
              (each [_ x (ipairs after)] (table.insert out x)))
            (b:write (b:join b.src "nss/coreconf/rules.mk") (.. (table.concat out "\n") (if (and ends (> (length out) 0)) "\n" "")))))
 :build (fn [b]
          (b:run ["make" "-j1" "BUILD_OPT=1" "NSS_USE_SYSTEM_SQLITE=1" "USE_SYSTEM_ZLIB=1" "USE_64=1" (.. "XCFLAGS=" (or (b:getenv "CFLAGS") ""))] {:cwd b.name}))
 :install (fn [b]
          (b:mkdir (.. b.prefix "/bin"))
          (b:mkdir (.. b.prefix "/include/nss"))
          (b:mkdir (.. b.prefix "/lib"))
          ;; Each tool from the build's dist/Linux* directory, executable, into bin.
          (each [_ dist (ipairs (b:glob (b:join b.src "dist") "Linux*"))]
            (let [tools (b:glob (.. dist "/bin") "*util")]
              (each [_ name (ipairs ["derdump" "pp" "shlibsign" "signtool" "signver" "ssltap" "vfychain" "vfyserv"])]
                (table.insert tools (.. dist "/bin/" name)))
              (each [_ f (ipairs tools)]
                (b:copy f (.. b.prefix "/bin/" (f:match "[^/]+$")))
                (b:chmod (.. b.prefix "/bin/" (f:match "[^/]+$")) "755"))))
          (each [_ p (ipairs (b:glob (b:join b.src "dist/public/nss") "*.h"))] (b:copy p (b:join (.. b.prefix "/include/nss") (: p :match "[^/]+$"))) (b:chmod (b:join (.. b.prefix "/include/nss") (: p :match "[^/]+$")) "0644"))
          ;; Each shared library from the build's dist/Linux* directory, into lib.
          (each [_ dist (ipairs (b:glob (b:join b.src "dist") "Linux*"))]
            (each [_ f (ipairs (b:glob (.. dist "/lib") "*.so"))]
              (b:copy f (.. b.prefix "/lib/" (f:match "[^/]+$")))
              (b:chmod (.. b.prefix "/lib/" (f:match "[^/]+$")) "755")))
          ;; Each library check file and libcrmf.a from the build's dist/Linux* directory, into lib.
          (each [_ dist (ipairs (b:glob (b:join b.src "dist") "Linux*"))]
            (let [files (b:glob (.. dist "/lib") "*.chk")]
              (table.insert files (.. dist "/lib/libcrmf.a"))
              (each [_ f (ipairs files)]
                (b:copy f (.. b.prefix "/lib/" (f:match "[^/]+$")))
                (b:chmod (.. b.prefix "/lib/" (f:match "[^/]+$")) "644")))))}
