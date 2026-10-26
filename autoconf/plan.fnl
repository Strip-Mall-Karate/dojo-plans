;; autoconf, ported from its plan.sh.
{:name "autoconf"
 :origin "karate"
 :version "2.69"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["GPL-2.0"]
 :description "Autoconf is an extensible package of M4 macros that produce shell scripts to automatically configure software source code packages."
 :upstream_url "https://www.gnu.org/software/autoconf/autoconf.html"
 :source {:url "http://ftp.gnu.org/gnu/autoconf/autoconf-2.69.tar.xz" :sha256 "64ebcec9f8ac5b2487125a86a7760d2591ac9e1d3dbd59489633f9de62a57684"}
 :deps ["karate/m4" "karate/perl"]
 :build_deps ["karate/diffutils" "karate/inetutils" "karate/gcc" "karate/make"]
 :bin_dirs ["bin"]}
