;; xcb-proto, ported from its plan.sh.
{:name "xcb-proto"
 :origin "karate"
 :version "1.12"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["MIT"]
 :description "X11 client library"
 :upstream_url "https://www.x.org/"
 :source {:url "https://www.x.org/releases/individual/xcb/xcb-proto-1.12.tar.bz2" :sha256 "5922aba4c664ab7899a29d92ea91a87aa4c1fc7eb5ee550325c3216c480a4906"}
 :build_deps ["karate/gcc" "karate/libxml2" "karate/make" "karate/python2"]
 :pconfig_dirs ["lib/pkgconfig"]
 :prepare (fn [b]
          ;; From do_setup_environment.
          (b:runtime_env_push "PYTHONPATH" (.. b.prefix "/lib/python2.7/site-packages"))
          (b.default.prepare b))}
