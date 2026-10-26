;; mesa, ported from its plan.sh.
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
{:name "mesa"
 :origin "karate"
 :version "17.2.5"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["MIT"]
 :description "The Mesa 3D Graphics Library"
 :upstream_url "https://www.mesa3d.org"
 :source {:url "https://mesa.freedesktop.org/archive/mesa-17.2.5.tar.xz" :sha256 "7f7f914b7b9ea0b15f2d9d01a4375e311b0e90e55683b8e8a67ce8691eb1070f"}
 :deps ["karate/elfutils" "karate/expat" "karate/gcc-libs" "karate/glibc" "karate/libdrm" "karate/libpciaccess" "karate/libxau" "karate/libxcb" "karate/libxdamage" "karate/libxdmcp" "karate/libxext" "karate/libxfixes" "karate/libxshmfence" "karate/xlib" "karate/zlib"]
 :build_deps ["karate/bison" "karate/damageproto" "karate/diffutils" "karate/dri2proto" "karate/file" "karate/fixesproto" "karate/flex" "karate/gcc" "karate/glproto" "karate/kbproto" "karate/libpthread-stubs" "karate/llvm" "karate/make" "karate/pkg-config" "karate/python2" "karate/xextproto" "karate/xproto" "karate/patch"]
 :lib_dirs ["lib" "lib/dri"]
 :include_dirs ["include"]
 :pconfig_dirs ["lib/pkgconfig"]
 :prepare (fn [b]
          (use-dependency-path b "/usr/bin/file" (b:path_for "file" "bin/file"))
          (b:run ["patch" "-p0" "-i" (.. b.plan_dir "/patches/000-llvm7-support.patch")])
          (b:run ["patch" "-p0" "-i" (.. b.plan_dir "/patches/001-llvm-enable-new-fast-math-flags.patch")]))
 :build (fn [b]
          (b:run ["./configure" (.. "--prefix=" b.prefix) "--enable-gles1" "--enable-gles2" "--enable-llvm" "--disable-llvm-shared-libs"])
          (b:run ["make"]))
 :strip (fn [b]
          (b.default.strip b)
          ;; From do_end.
          )}
