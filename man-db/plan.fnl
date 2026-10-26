;; man-db, ported from its plan.sh.
{:name "man-db"
 :origin "karate"
 :version "2.7.5"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["GPL-2.0"]
 :description "man-db is an implementation of the standard Unix documentation system accessed using the man command."
 :upstream_url "http://man-db.nongnu.org/"
 :source {:url "http://git.savannah.gnu.org/cgit/man-db.git/snapshot/man-db-2.7.5.tar.gz" :sha256 "3a1af4b7f17193e45b5abdb12d935b70a7757dfe7e1a4196f6c00b500c6fca78"}
 :deps ["karate/gdbm" "karate/glibc" "karate/groff" "karate/gzip" "karate/libiconv"]
 :build_deps ["karate/coreutils" "karate/diffutils" "karate/flex" "karate/gcc" "karate/gettext" "karate/libpipeline" "karate/make" "karate/m4" "karate/pkg-config"]
 :bin_dirs ["bin" "sbin"]
 :lib_dirs ["lib/man-db"]
 :prepare (fn [b]
          (let [text (b:read (.. b.src "/src/man_db.conf.in")) ends (= (text:sub -1) "\n") lines [] out []]
            (each [l (string.gmatch (if ends text (.. text "\n")) "(.-)\n")] (table.insert lines l))
            (each [n l (ipairs lines)]
              (var line l) (var deleted false) (local after [])
              (when (not deleted) (set line (pick-values 1 (string.gsub line "/var/" (.. (pick-values 1 (: "/doj/svc/man-db/var" :gsub "%%" "%%%%")) "/")))))
              (when (not deleted) (table.insert out line))
              (each [_ x (ipairs after)] (table.insert out x)))
            (b:write (.. b.src "/src/man_db.conf.in") (.. (table.concat out "\n") (if (and ends (> (length out) 0)) "\n" "")))))
 :build (fn [b]
          (b:run ["./configure" (.. "--prefix=" b.prefix) "--disable-setuid" "--disable-silent-rules" "--enable-automatic-create" "--enable-mandirs=GNU" "--enable-threads=posix" "--enable-mb-groff" (.. "--with-gzip=" (b:path_for "gzip") "/bin/gzip") (.. "--with-libiconv-prefix=" (b:path_for "libiconv")) "--with-systemdtmpfilesdir=/doj/svc/man-db/config/tmpfiles.d"])
          (b:run ["make"]))
 :check (fn [b]
          (b:run ["make" "check"]))
 :install (fn [b]
          (b.default.install b)
          (let [text (b:read "/doj/svc/man-db/config/tmpfiles.d/man-db.conf") ends (= (text:sub -1) "\n") lines [] out []]
            (each [l (string.gmatch (if ends text (.. text "\n")) "(.-)\n")] (table.insert lines l))
            (each [n l (ipairs lines)]
              (var line l) (var deleted false) (local after [])
              (when (not deleted) (set line (pick-values 1 (string.gsub line "man root" "root root"))))
              (when (not deleted) (table.insert out line))
              (each [_ x (ipairs after)] (table.insert out x)))
            (b:write "/doj/svc/man-db/config/tmpfiles.d/man-db.conf" (.. (table.concat out "\n") (if (and ends (> (length out) 0)) "\n" "")))))}
