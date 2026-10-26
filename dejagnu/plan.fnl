;; dejagnu, ported from its plan.sh.
{:name "dejagnu"
 :origin "karate"
 :version "1.6.1"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["GPL-3.0-or-later"]
 :description "A framework for testing other programs."
 :upstream_url "https://www.gnu.org/software/dejagnu/"
 :source {:url "https://ftp.gnu.org/gnu/dejagnu/dejagnu-1.6.1.tar.gz" :sha256 "bf5b28bb797e0ace4cfc0766a996339c795d8223bef54158be7887046bc01692"}
 :deps ["karate/expect" "karate/coreutils" "karate/sed" "karate/grep"]
 :build_deps ["karate/diffutils" "karate/patch" "karate/make" "karate/gcc"]
 :bin_dirs ["bin"]
 :include_dirs ["include"]
 :check (fn [b]
          (b:run ["make" "check"]))
 :install (fn [b]
          (b.default.install b)
          (let [text (b:read (.. b.prefix "/bin/runtest"))] (b:write (.. b.prefix "/bin/runtest") (pick-values 1 (string.gsub text "[^\n]+" (fn [l] (var line l) (set line (pick-values 1 (string.gsub line "expectbin=expect" (.. "expectbin=" (pick-values 1 (: (b:path_for "expect") :gsub "%%" "%%%%")) "/bin/expect")))) line))))))}
