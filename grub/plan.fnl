;; grub, ported from its plan.sh.
;; grub 2.14, the latest release on 2026-10-26: 2.02's source no longer downloads. Written by hand.
;; One package with both of an x86_64 machine's boot paths: i386-pc for BIOS and
;; x86_64-efi for UEFI, each configured in its own directory and installed into the same
;; prefix, where grub-install --target picks one. Device mapper, fonts, themes, FUSE and
;; NLS are left out: a Dojo disk is a plain partition table and a serial console.
(local platforms [["pc" "i386"] ["efi" "x86_64"]])

(fn build-dir [b platform]
  (b:join b.src (.. "build-" platform)))

{:name "grub"
 :origin "karate"
 :version "2.14"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["GPL-3.0"]
 :description "GNU GRUB is a Multiboot boot loader."
 :upstream_url "https://www.gnu.org/software/grub/"
 :source {:url "https://ftp.gnu.org/gnu/grub/grub-2.14.tar.xz" :sha256 "bc8d3c73535b8838d8c8e2654d73edc4e6ae8c8acdb45d5df5dc9a1547446d43"}
 :deps ["karate/glibc" "karate/gcc-libs"]
 :build_deps ["karate/binutils" "karate/bison" "karate/flex" "karate/gcc" "karate/make" "karate/python" "karate/pkg-config"]
 :bin_dirs ["bin" "sbin"]
 :build (fn [b]
          (each [_ [platform target] (ipairs platforms)]
            (let [dir (build-dir b platform)]
              (b:mkdir dir)
              (b:run ["../configure" (.. "--prefix=" b.prefix) (.. "--with-platform=" platform) (.. "--target=" target)
                      "--disable-nls" "--disable-werror" "--disable-efiemu" "--disable-device-mapper"
                      "--disable-grub-mkfont" "--disable-grub-themes" "--disable-grub-mount" "--disable-libzfs"
                      "--disable-liblzma"]
                     {:cwd dir})
              (b:run ["make" "-j" (tostring b.jobs)] {:cwd dir}))))
 :install (fn [b]
            (each [_ [platform] (ipairs platforms)]
              (b:run ["make" "install"] {:cwd (build-dir b platform)})))
 ;; grub-install strips the modules it needs as it installs them; a strip here would
 ;; take the symbols the boot images link by.
 :strip (fn [b] nil)}
