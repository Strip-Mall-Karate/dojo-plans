;; mg, ported from its plan.sh.
{:name "mg"
 :origin "karate"
 :version "20180408"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["publicdomain"]
 :description "mg is Micro GNU/emacs, this is a portable version of the mg maintained by the OpenBSD team."
 :upstream_url "https://homepage.boetes.org/software/mg/"
 :source {:url "https://github.com/hboetes/mg/archive/20180408.tar.gz" :sha256 "85c1d47500fd042e427b670c630c228668bcc4f532a280f9ecce3d302229bbe4"}
 :deps ["karate/glibc" "karate/ncurses" "karate/libbsd"]
 :build_deps ["karate/coreutils" "karate/diffutils" "karate/patch" "karate/make" "karate/gcc" "karate/sed" "karate/pkg-config" "karate/clens"]
 :bin_dirs ["bin"]
 :prepare (fn [b]
          (b:run ["patch" "-p1"] {:stdin (let [text (b:read (.. b.plan_dir "/cleanup.patch")) ends (= (text:sub -1) "\n") lines [] out []]
            (each [l (string.gmatch (if ends text (.. text "\n")) "(.-)\n")] (table.insert lines l))
            (each [n l (ipairs lines)]
              (var line l) (var deleted false) (local after [])
              (when (not deleted) (set line (pick-values 1 (string.gsub line "@prefix@" (pick-values 1 (: b.prefix :gsub "%%" "%%%%"))))))
              (when (not deleted) (set line (pick-values 1 (string.gsub line "@clens_prefix@" (pick-values 1 (: (b:path_for "clens") :gsub "%%" "%%%%"))))))
              (when (not deleted) (set line (pick-values 1 (string.gsub line "@libbsd_prefix@" (pick-values 1 (: (b:path_for "libbsd") :gsub "%%" "%%%%"))))))
              (when (not deleted) (table.insert out line))
              (each [_ x (ipairs after)] (table.insert out x)))
            (.. (table.concat out "\n") (if (and ends (> (length out) 0)) "\n" "")))}))
 :build (fn [b]
          (var v-prefix "")
          (b:run ["make" (.. "prefix=" b.prefix) "PKG_CONFIG=pkg-config" "INSTALL=install" "STRIP=strip"]))
 :install (fn [b]
          (b.default.install b)
          (b:copy (b:join b.src "README") (.. b.prefix "/share/licenses/README"))
          (b:chmod (.. b.prefix "/share/licenses/README") "644"))}
