;; pcre2 10.49, the latest release on 2026-10-26. Written for Dojo: grep 3.8 and later use PCRE2.
{:name "pcre2"
 :origin "karate"
 :version "10.49"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["BSD-3-Clause WITH PCRE2-exception"]
 :description "PCRE2 is a library of functions that implement regular expression pattern matching using the same syntax and semantics as Perl 5, with its own native API."
 :upstream_url "https://github.com/PCRE2Project/pcre2"
 :source {:url "https://github.com/PCRE2Project/pcre2/releases/download/pcre2-10.49/pcre2-10.49.tar.bz2" :sha256 "53c156e1ba416a20da8e65395daa132da0d80e76910424caca3fcdae7831d384"}
 :deps ["karate/glibc"]
 :build_deps ["karate/coreutils" "karate/diffutils" "karate/make" "karate/gcc"]
 :bin_dirs ["bin"]
 :lib_dirs ["lib"]
 :include_dirs ["include"]
 :pconfig_dirs ["lib/pkgconfig"]
 :build (fn [b]
          (b:run ["./configure" (.. "--prefix=" b.prefix) "--enable-unicode" "--enable-jit" "--enable-pcre2-16" "--enable-pcre2-32"])
          (b:run ["make" (.. "-j" (tostring b.jobs))]))
 :check (fn [b]
          (b:run ["make" "check"]))
 :install (fn [b]
          (b.default.install b)
          (b:mkdir (.. b.prefix "/share/licenses"))
          (b:copy (b:join b.src "LICENCE.md") (.. b.prefix "/share/licenses/LICENSE.md")))}
