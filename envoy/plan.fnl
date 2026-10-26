;; envoy, ported from its plan.sh.
{:name "envoy"
 :origin "karate"
 :version "e5f864a82d4f27110359daa2fbdcb12d99e415b9"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["Apache-2.0"]
 :description "Build and test software of any size, quickly and reliably"
 :upstream_url "https://www.envoyproxy.io/"
 :deps ["karate/glibc"]
 :build_deps ["karate/curl" "karate/jq-static" "karate/patchelf" "karate/coreutils" "karate/go"]
 :bin_dirs ["bin"]
 :download (fn [b]
          (b:run ["curl" "https://raw.githubusercontent.com/moby/moby/master/contrib/download-frozen-image-v2.sh" "-o" (.. b.cache "/download-frozen-image-v2.sh")])
          (let [text (b:read (.. b.cache "/download-frozen-image-v2.sh"))] (b:write (.. b.cache "/download-frozen-image-v2.sh") (pick-values 1 (string.gsub text "[^\n]+" (fn [l] (var line l) (set line (pick-values 1 (string.gsub line "#!/usr/bin/env bash" "#!/bin/bash" 1))) line)))))
          (b:chmod (.. b.cache "/download-frozen-image-v2.sh") "+x")
          (b:run [(.. b.cache "/download-frozen-image-v2.sh") (.. b.cache "/envoy") (.. "envoyproxy/envoy:" b.version)]))
 :verify (fn [b]
          nil)
 :unpack (fn [b]
          (b:mkdir b.src)
          (b:run ["find" (.. b.cache "/envoy") "-name" "*.tar" "-exec" "tar" "-xf" "{}" "-C" b.src ";"]))
 :build (fn [b]
          nil)
 :install (fn [b]
          (b:mkdir (.. b.prefix "/bin/"))
          (if (b:exists (.. b.prefix "/bin/envoy"))
            (b:copy (b:join b.src "usr/local/bin/envoy") (b:join (.. b.prefix "/bin/envoy") (: (b:join b.src "usr/local/bin/envoy") :match "[^/]+$")))
            (b:copy (b:join b.src "usr/local/bin/envoy") (.. b.prefix "/bin/envoy")))
          (b:run ["patchelf" "--interpreter" (.. (b:path_for "glibc") "/lib/ld-linux-x86-64.so.2") "--set-rpath" (or (b:getenv "LD_RUN_PATH") "") (.. b.prefix "/bin/envoy")]))
 :strip (fn [b]
          nil)}
