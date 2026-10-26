;; grub, ported from its plan.sh.
;; The plan's do_setup and the do_after cleanup it armed are not ported: the source
;; project's builder never called do_setup, so neither ever ran.
{:name "grub"
 :origin "karate"
 :version "2.02"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["GPL-3.0"]
 :description "GNU GRUB is a Multiboot boot loader."
 :upstream_url "https://www.gnu.org/software/grub/"
 :source {:url "ftp://ftp.gnu.org/gnu/grub/grub-2.02.tar.xz" :sha256 "810b3798d316394f94096ec2797909dbf23c858e48f7b3830826b8daa06b7b0f"}
 :deps ["karate/glibc" "karate/xz" "karate/gettext" "karate/pcre" "karate/gcc-libs" "karate/devicemapper" "karate/elfutils" "karate/bzip2" "karate/libcap"]
 :build_deps ["karate/autoconf" "karate/automake" "karate/binutils" "karate/bison" "karate/cacerts" "karate/diffutils" "karate/dosfstools" "karate/flex" "karate/freetype" "karate/gcc" "karate/gettext" "karate/git" "karate/m4" "karate/make" "karate/python" "karate/qemu" "karate/rsync" "karate/texinfo" "karate/patch"]
 :bin_dirs ["bin" "sbin"]
 :prepare (fn [b]
          (b:run ["patch" "-Np1" "-i" (.. b.plan_dir "/patches/001-fix-packed-not-aligned-error-on-GCC-8.patch")]))
 :build (fn [b]
          (let [text (b:read (b:join b.src "autogen.sh")) ends (= (text:sub -1) "\n") lines [] out []]
            (each [l (string.gmatch (if ends text (.. text "\n")) "(.-)\n")] (table.insert lines l))
            (each [n l (ipairs lines)]
              (var line l) (var deleted false) (local after [])
              (when (not deleted) (set line (pick-values 1 (string.gsub line "#! /usr/bin/env bash" "#!/bin/bash" 1))))
              (when (not deleted) (table.insert out line))
              (each [_ x (ipairs after)] (table.insert out x)))
            (b:write (b:join b.src "autogen.sh") (.. (table.concat out "\n") (if (and ends (> (length out) 0)) "\n" ""))))
          (b:run ["./linguas.sh"])
          (b:run ["./autogen.sh"])
          (b:run ["./configure" (.. "--prefix=" b.prefix) "--with-bootdir=/boot" "--target=x86_64" "--enable-efiemu" "--enable-mm-debug" "--enable-nls" "--enable-device-mapper" "--enable-cache-stats" "--enable-boot-time" "--enable-grub-mkfont" "--with-grubdir=grub" "--disable-silent-rules" "--disable-werror"])
          (b:run ["make" "-j" (tostring b.jobs)]))
 :check (fn [b]
          (b:run ["make" "-j" (tostring b.jobs) "check"]))
}
