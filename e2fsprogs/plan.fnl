;; e2fsprogs, ported from its plan.sh.
;; e2fsprogs 1.47.4, the latest release on 2026-10-27: 1.44.1 does not build with gcc 16.
{:name "e2fsprogs"
 :origin "karate"
 :version "1.47.4"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["GPL-2.0"]
 :description "Ext2/3/4 filesystem userspace utilities"
 :upstream_url "http://e2fsprogs.sourceforge.net/"
 :source {:url "https://www.kernel.org/pub/linux/kernel/people/tytso/e2fsprogs/v1.47.4/e2fsprogs-1.47.4.tar.xz" :sha256 "fd5bf388cbdbe006a3d3b318d983b2948382440acc85a87f1e7d108653e8db0b"}
 :deps ["karate/glibc"]
 :build_deps ["karate/make" "karate/gcc" "karate/pkg-config"]
 :bin_dirs ["bin" "sbin"]
 :lib_dirs ["lib"]
 :include_dirs ["include"]
 ;; Without the pieces that install outside the package (udev rules, cron and systemd
 ;; units) or need what a package does not ship (FUSE, gettext, a uuidd service).
 :build (fn [b]
          (b:run ["./configure" (.. "--prefix=" b.prefix) "--disable-nls" "--disable-fuse2fs" "--disable-uuidd"
                  "--with-udev-rules-dir=no" "--with-crond-dir=no" "--with-systemd-unit-dir=no"])
          (b:run ["make" "-j" (tostring b.jobs)]))
 ;; e2scrub checks a filesystem in an LVM snapshot, which no package here provides, and is
 ;; a bash script.
 :install (fn [b]
            (b.default.install b)
            (each [_ f (ipairs ["sbin/e2scrub" "sbin/e2scrub_all"])]
              (b:remove (b:join b.prefix f))))}
