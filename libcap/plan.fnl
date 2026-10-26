;; libcap, ported from its plan.sh.
{:name "libcap"
 :origin "karate"
 :version "2.25"
 :targets ["x86_64-linux" "x86_64-linux-kernel2"]
 :maintainer "Strip Mall Karate Company"
 :license ["gplv2"]
 :description "POSIX 1003.1e capabilities."
 :upstream_url "http://sites.google.com/site/fullycapable/"
 :source {:url "https://www.kernel.org/pub/linux/libs/security/linux-privs/libcap2/libcap-2.25.tar.xz" :sha256 "693c8ac51e983ee678205571ef272439d83afe62dd8e424ea14ad9790bc35162"}
 :deps ["karate/glibc" "karate/attr"]
 :build_deps ["karate/coreutils" "karate/diffutils" "karate/patch" "karate/make" "karate/gcc" "karate/linux-headers" "karate/perl"]
 :bin_dirs ["bin"]
 :lib_dirs ["lib"]
 :include_dirs ["include"]
 :prepare (fn [b]
          (b.default.prepare b)
          (let [text (b:read (b:join b.src "Make.Rules")) ends (= (text:sub -1) "\n") lines [] out []]
            (each [l (string.gmatch (if ends text (.. text "\n")) "(.-)\n")] (table.insert lines l))
            (each [n l (ipairs lines)]
              (var line l) (var deleted false) (local after [])
              (when (not deleted) (when (string.find line "SBINDIR") (set line (pick-values 1 (string.gsub line "sbin" "bin" 1)))))
              (when (not deleted) (table.insert out line))
              (each [_ x (ipairs after)] (table.insert out x)))
            (b:write (b:join b.src "Make.Rules") (.. (table.concat out "\n") (if (and ends (> (length out) 0)) "\n" "")))))
 :build (fn [b]
          (b:run ["make" (.. "KERNEL_HEADERS=" (b:path_for "linux-headers") "/include") (.. "LDFLAGS=" (or (b:getenv "LDFLAGS") ""))]))
 :install (fn [b]
          (b:run ["make" (.. "prefix=" b.prefix) "lib=lib" "RAISE_SETFCAP=no" "install"]))
 :on {"x86_64-linux-kernel2"
      {:version "2.25"
       :license ["gplv2"]
       :description "POSIX 1003.1e capabilities."
       :upstream_url "http://sites.google.com/site/fullycapable/"
       :source {:url "https://www.kernel.org/pub/linux/libs/security/linux-privs/libcap2/libcap-2.25.tar.xz" :sha256 "693c8ac51e983ee678205571ef272439d83afe62dd8e424ea14ad9790bc35162"}
       :deps ["karate/glibc" "karate/attr"]
       :build_deps ["karate/coreutils" "karate/diffutils" "karate/patch" "karate/make" "karate/gcc" "karate/linux-headers" "karate/perl"]
       :bin_dirs ["bin"]
       :lib_dirs ["lib"]
       :include_dirs ["include"]
       :prepare (fn [b]
          (b.default.prepare b)
          (let [text (b:read (b:join b.src "Make.Rules")) ends (= (text:sub -1) "\n") lines [] out []]
            (each [l (string.gmatch (if ends text (.. text "\n")) "(.-)\n")] (table.insert lines l))
            (each [n l (ipairs lines)]
              (var line l) (var deleted false) (local after [])
              (when (not deleted) (when (string.find line "SBINDIR") (set line (pick-values 1 (string.gsub line "sbin" "bin" 1)))))
              (when (not deleted) (table.insert out line))
              (each [_ x (ipairs after)] (table.insert out x)))
            (b:write (b:join b.src "Make.Rules") (.. (table.concat out "\n") (if (and ends (> (length out) 0)) "\n" ""))))
          (b:run ["patch" "-p1" "-i" (.. b.plan_dir "/libcap-old-kernel-headers.patch")]))
       :build (fn [b]
          (b:run ["make" (.. "KERNEL_HEADERS=" (b:path_for "linux-headers") "/include") (.. "LDFLAGS=" (or (b:getenv "LDFLAGS") ""))]))
       :install (fn [b]
          (b:run ["make" (.. "prefix=" b.prefix) "lib=lib" "RAISE_SETFCAP=no" "install"]))}}}
