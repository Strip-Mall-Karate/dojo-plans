;; sed, ported from its plan.sh.
;; sed 4.10, the latest release on 2026-10-26.
{:name "sed"
 :origin "karate"
 :version "4.10"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["gplv3"]
 :description "sed (stream editor) is a non-interactive command-line text editor. sed is commonly used to filter text, i.e., it takes text input, performs some operation (or set of operations) on it, and outputs the modified text. sed is typically used for extracting part of a file using pattern matching or substituting multiple occurrences of a string within a file."
 :upstream_url "https://www.gnu.org/software/sed/"
 :source {:url "https://ftp.gnu.org/gnu/sed/sed-4.10.tar.xz" :sha256 "b8e72182b2ec96a3574e2998c47b7aaa64cc20ce000d8e9ac313cc07cecf28c7"}
 :deps ["karate/glibc" "karate/acl"]
 :build_deps ["karate/coreutils" "karate/diffutils" "karate/patch" "karate/make" "karate/gcc"]
 :bin_dirs ["bin"]
 :prepare (fn [b]
          (b:run ["patch" "-p1" "-i" (.. b.plan_dir "/fix-test-getopt-posix-with-glibc-2.26.patch")])
          (let [text (b:read (b:join b.src "Makefile.in")) ends (= (text:sub -1) "\n") lines [] out []]
            (each [l (string.gmatch (if ends text (.. text "\n")) "(.-)\n")] (table.insert lines l))
            (each [n l (ipairs lines)]
              (var line l) (var deleted false) (local after [])
              (when (not deleted) (set line (pick-values 1 (string.gsub line "testsuite.panic%-tests.sh" "" 1))))
              (when (not deleted) (table.insert out line))
              (each [_ x (ipairs after)] (table.insert out x)))
            (b:write (b:join b.src "Makefile.in") (.. (table.concat out "\n") (if (and ends (> (length out) 0)) "\n" "")))))
 :check (fn [b]
          (b:run ["make" "check"]))}
