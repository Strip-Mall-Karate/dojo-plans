;; make, ported from its plan.sh.
{:name "make"
 :origin "karate"
 :version "4.2.1"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["GPL-3.0"]
 :description "Make is a tool which controls the generation of executables and other non-source files of a program from the program's source files."
 :upstream_url "https://www.gnu.org/software/make/"
 :source {:url "http://ftp.gnu.org/gnu/make/make-4.2.1.tar.bz2" :sha256 "d6e262bf3601b42d2b1e4ef8310029e1dcf20083c5446b4b7aa67081fdffc589"}
 :deps ["karate/glibc"]
 :build_deps ["karate/coreutils" "karate/diffutils" "karate/patch" "karate/make" "karate/gcc" "karate/bash" "karate/gettext" "karate/gzip" "karate/perl" "karate/binutils"]
 :bin_dirs ["bin"]
 :include_dirs ["include"]
 :prepare (fn [b]
          (b.default.prepare b)
          (b:run ["patch" "-p1" "-i" (.. b.plan_dir "/no-sys-dirs.patch")])
          (let [text (b:read (b:join b.src "glob/glob.c")) ends (= (text:sub -1) "\n") lines [] out []]
            (each [l (string.gmatch (if ends text (.. text "\n")) "(.-)\n")] (table.insert lines l))
            (each [n l (ipairs lines)]
              (var line l) (var deleted false) (local after [])
              (when (not deleted) (when (and (>= n 211) (<= n 217)) (set deleted true)))
              (when (not deleted) (when (and (>= n 219) (<= n 229)) (set deleted true)))
              (when (not deleted) (when (= n 232) (set deleted true)))
              (when (not deleted) (table.insert out line))
              (each [_ x (ipairs after)] (table.insert out x)))
            (b:write (b:join b.src "glob/glob.c") (.. (table.concat out "\n") (if (and ends (> (length out) 0)) "\n" "")))))
 :check (fn [b]
          (b:mkdir (b:join b.src "wrappers"))
          (b:write (b:join b.src "wrappers/ar") (.. "#!" (b:path_for "bash") "/bin/sh\nexec " (b:path_for "binutils") "/bin/ar U$@\n"))
          (b:chmod (b:join b.src "wrappers/ar") "0744")
          (b:run ["env" (.. "PATH=" (b:capture ["pwd"]) "/wrappers:" (or (b:getenv "PATH") "")) "PERL_USE_UNSAFE_INC=1" "make" "check"]))}
