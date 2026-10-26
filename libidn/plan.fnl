;; libidn, ported from its plan.sh.
{:name "libidn"
 :origin "karate"
 :version "1.35"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["LGPL-2.0-or-later"]
 :description "GNU Libidn is a fully documented implementation of the Stringprep, Punycode and IDNA 2003 specifications."
 :upstream_url "https://www.gnu.org/software/libidn/"
 :source {:url "http://ftp.gnu.org/gnu/libidn/libidn-1.35.tar.gz" :sha256 "f11af1005b46b7b15d057d7f107315a1ad46935c7fcdf243c16e46ec14f0fe1e"}
 :deps ["karate/glibc"]
 :build_deps ["karate/coreutils" "karate/diffutils" "karate/patch" "karate/make" "karate/gcc"]
 :bin_dirs ["bin"]
 :lib_dirs ["lib"]
 :include_dirs ["include"]
 :pconfig_dirs ["lib/pkgconfig"]
 :check (fn [b]
          (b:run ["make" "check"]))}
