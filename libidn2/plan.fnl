;; libidn2, ported from its plan.sh.
{:name "libidn2"
 :origin "karate"
 :version "2.0.4"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["GPL-2.0" "LGPL-3.0"]
 :description "Implementation of IDNA2008, Punycode and TR46 (Internationalized domain names)"
 :upstream_url "https://www.gnu.org/software/libidn/#libidn2"
 :source {:url "https://ftp.gnu.org/gnu/libidn/libidn2-2.0.4.tar.gz" :sha256 "644b6b03b285fb0ace02d241d59483d98bc462729d8bb3608d5cad5532f3d2f0"}
 :deps ["karate/glibc" "karate/libiconv" "karate/libunistring"]
 :build_deps ["karate/diffutils" "karate/gcc" "karate/gettext" "karate/make" "karate/pkg-config"]
 :bin_dirs ["bin"]
 :lib_dirs ["lib"]
 :include_dirs ["include"]
 :pconfig_dirs ["lib/pkgconfig"]
 :check (fn [b]
          (b:run ["make" "check"]))}
