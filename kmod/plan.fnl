;; kmod, ported from its plan.sh.
{:name "kmod"
 :origin "karate"
 :version "24"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["LGPL-2.1"]
 :description "Linux kernel module management tools and library"
 :upstream_url "https://git.kernel.org/pub/scm/utils/kernel/kmod/kmod.git"
 :source {:url "https://www.kernel.org/pub/linux/utils/kernel/kmod/kmod-24.tar.xz" :sha256 "610b8d1df172acc39a4fdf1eaa47a57b04873c82f32152e7a62e29b6ff9cb397"}
 :deps ["karate/glibc" "karate/xz" "karate/zlib"]
 :build_deps ["karate/make" "karate/gcc" "karate/pkg-config" "karate/file" "karate/sed" "karate/diffutils"]
 :bin_dirs ["bin"]
 :lib_dirs ["lib"]
 :include_dirs ["include"]
 :pconfig_dirs ["lib/pkgconfig"]
 :download (fn [b]
          ;; From do_before.
          (when (not (b:exists "/usr/bin/file"))
            (b:run ["doj" "pkg" "binlink" "karate/file" "file" "-d" "/usr/bin"]) (var v--clean-file "true"))
          (b.default.download b))
 :build (fn [b]
          (b:run ["./configure" (.. "--prefix=" b.prefix) "--with-xz" "--with-zlib"])
          (b:run ["make"]))
 :install (fn [b]
          (b.default.install b)
          (each [_ v-bin (ipairs ["{depmod,insmod,lsmod,modinfo,modprobe,rmmod}"])]
            (b:symlink "kmod" v-bin)))
 :strip (fn [b]
          (b.default.strip b)
          ;; From do_end.
          )}
