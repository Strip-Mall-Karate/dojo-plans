;; bc, ported from its plan.sh.
{:name "bc"
 :origin "karate"
 :version "1.07.1"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["GPL-3.0"]
 :description "bc is an arbitrary precision numeric processing language. Syntax is similar to C, but differs in many substantial areas. It supports interactive execution of statements. bc is a utility included in the POSIX P1003.2/D11 draft standard."
 :upstream_url "https://www.gnu.org/software/bc/"
 :source {:url "https://ftp.gnu.org/gnu/bc/bc-1.07.1.tar.gz" :sha256 "62adfca89b0a1c0164c2cdca59ca210c1d44c3ffc46daf9931cf4942664cb02a"}
 :deps ["karate/flex" "karate/glibc" "karate/ncurses" "karate/readline"]
 :build_deps ["karate/bison" "karate/coreutils" "karate/diffutils" "karate/gcc" "karate/make" "karate/patch" "karate/texinfo"]
 :bin_dirs ["bin"]
 :prepare (fn [b]
          (let [text (b:read (b:join b.src "configure")) ends (= (text:sub -1) "\n") lines [] out []]
            (each [l (string.gmatch (if ends text (.. text "\n")) "(.-)\n")] (table.insert lines l))
            (each [n l (ipairs lines)]
              (var line l) (var deleted false) (local after [])
              (when (not deleted) (when (string.find line "flex") (set line (pick-values 1 (string.gsub line "as_fn_error" ": ;; # %0" 1)))))
              (when (not deleted) (table.insert out line))
              (each [_ x (ipairs after)] (table.insert out x)))
            (b:write (b:join b.src "configure") (.. (table.concat out "\n") (if (and ends (> (length out) 0)) "\n" ""))))
          (b:write (b:join b.src "bc/fix-libmath_h") "#!/bin/bash\nsed -e '1   s/^/{\"/' \\\n    -e     's/$/\",/' \\\n    -e '2,$ s/^/\"/'  \\\n    -e   '$ d'       \\\n    -i libmath.h\n\nsed -e '$ s/$/0}/' \\\n    -i libmath.h\n"))
 :build (fn [b]
          (b:run ["./configure" (.. "--prefix=" b.prefix) "--with-readline"])
          (b:run ["make"]))
 :check (fn [b]
          ;; bc reads the test file, then quits at the end of its input, which a build's
          ;; programs read as empty: what piping in `quit` did.
          (b:run ["./bc/bc" "-l" "Test/checklib.b"]))}
