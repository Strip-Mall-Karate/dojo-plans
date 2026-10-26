;; atk, ported from its plan.sh.
{:name "atk"
 :origin "karate"
 :version "2.27.1"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["LGPL-2.0"]
 :description "Library for a set of interfaces providing accessibility. By supporting the ATK interfaces, an application or toolkit can be used with tools such as screen readers, magnifiers, and alternative input devices."
 :upstream_url "https://developer.gnome.org/atk/"
 :source {:url "https://download.gnome.org/sources/atk/2.27/atk-2.27.1.tar.xz" :sha256 "673a953987b301ab1e24e7d11677b6e7ba3226411a168449ba946765b6d44297"}
 :deps ["karate/glib" "karate/glibc" "karate/libffi" "karate/libiconv" "karate/pcre"]
 :build_deps ["karate/diffutils" "karate/gcc" "karate/gettext" "karate/make" "karate/perl" "karate/pkg-config"]
 :lib_dirs ["lib"]
 :include_dirs ["include"]
 :pconfig_dirs ["lib/pkgconfig"]}
