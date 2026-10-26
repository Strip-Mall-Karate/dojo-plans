;; gzip, ported from its plan.sh.
{:name "gzip"
 :origin "karate"
 :version "1.9"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["gplv3+"]
 :description "GNU Gzip is a popular data compression program originally written by Jean-loup Gailly for the GNU project."
 :upstream_url "https://www.gnu.org/software/gzip/"
 :source {:url "http://ftp.gnu.org/gnu/gzip/gzip-1.9.tar.xz" :sha256 "ae506144fc198bd8f81f1f4ad19ce63d5a2d65e42333255977cf1dcf1479089a"}
 :deps ["karate/glibc" "karate/less" "karate/grep"]
 :build_deps ["karate/coreutils" "karate/diffutils" "karate/patch" "karate/make" "karate/gcc" "karate/sed" "karate/xz"]
 :bin_dirs ["bin"]
 :prepare (fn [b]
          (b.default.prepare b)
          (b:log "Patching 'zless' with the full path to 'less'")
          (let [text (b:read (b:join b.src "zless.in"))] (b:write (b:join b.src "zless.in") (pick-values 1 (string.gsub text "[^\n]+" (fn [l] (var line l) (set line (pick-values 1 (string.gsub line "less %-V" (.. (pick-values 1 (: (b:path_for "less") :gsub "%%" "%%%%")) "/bin/less -V")))) (set line (pick-values 1 (string.gsub line "exec less" (.. "exec " (pick-values 1 (: (b:path_for "less") :gsub "%%" "%%%%")) "/bin/less")))) line))))))
 :build (fn [b]
          (b:run ["./configure" (.. "--prefix=" b.prefix)])
          (b:run ["make" (.. "-j" (tostring b.jobs)) (.. "GREP=" (b:path_for "grep") "/bin/grep") (.. "LESS=" (b:path_for "less") "/bin/less")]))
 :check (fn [b]
          (let [text (b:read (b:join b.src "tests/Makefile"))] (b:write (b:join b.src "tests/Makefile") (pick-values 1 (string.gsub text "[^\n]+" (fn [l] (var line l) (set line (pick-values 1 (string.gsub line "zmore" ""))) line)))))
          (b:run ["make" "check"]))}
