;; corretto11, ported from its plan.sh.
;; Built from the corretto plan, with its own changes.
{:name "corretto11"
 :origin "karate"
 :version "11.0.2.9.3"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["GPL-2.0-only"]
 :upstream_url "https://aws.amazon.com/corretto/"
 :source {:url "https://d3pxv6yz143wms.cloudfront.net/11.0.2.9.3/amazon-corretto-11.0.2.9.3-linux-x64.tar.gz" :sha256 "be8452a78baa077e19afbfa64070b26275030267a5ea4e837dec7a30eff85c9c" :filename "corretto-11.0.2.9.3_linux-x64_bin.tar.gz" :dirname "amazon-corretto-11.0.2.9.3-linux-x64"}
 :deps ["karate/alsa-lib" "karate/freetype" "karate/gcc-libs" "karate/glibc" "karate/libxext" "karate/libxi" "karate/libxrender" "karate/libxtst" "karate/xlib" "karate/zlib"]
 :build_deps ["karate/patchelf" "karate/rsync"]
 :bin_dirs ["bin"]
 :lib_dirs ["lib"]
 :include_dirs ["include"]
 :prepare (fn [b]
          ;; From do_setup_environment.
          (b:runtime_env "JAVA_HOME" b.prefix)
          (b.default.prepare b))
 :build (fn [b]
          nil)
 :install (fn [b]
          (b:run ["rsync" "-avz" "@{cache}/amazon-corretto-11.0.2.9.3-linux-x64/" "."] {:cwd b.prefix})
          (b:env "LD_RUN_PATH" (.. (or (b:getenv "LD_RUN_PATH") "") ":" b.prefix "/lib/jli:" b.prefix "/lib/server:" b.prefix "/lib"))
          (b:log (.. "Setting interpreter for all executables to '" (b:path_for "glibc") "/lib/ld-linux-x86-64.so.2'"))
          (b:log (.. "Setting rpath for all libraries to '" (or (b:getenv "LD_RUN_PATH") "") "'"))
          (b:run ["find" (.. b.prefix "/bin") "-type" "f" "-executable" "-exec" "sh" "-c" "file -i \"$1\" | grep -q \"x-executable; charset=binary\"" "_" "{}" ";" "-exec" "patchelf" "--interpreter" (.. (b:path_for "glibc") "/lib/ld-linux-x86-64.so.2") "--set-rpath" (or (b:getenv "LD_RUN_PATH") "") "{}" ";"] {:cwd b.prefix})
          (b:run ["find" (.. b.prefix "/lib") "-type" "f" "-name" "*.so" "-exec" "patchelf" "--set-rpath" (or (b:getenv "LD_RUN_PATH") "") "{}" ";"] {:cwd b.prefix}))
 :strip (fn [b]
          nil)}
