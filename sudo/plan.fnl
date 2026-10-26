;; sudo, ported from its plan.sh.
(fn use-dependency-path [b path replacement]
  ;; The source project's studio linked a dependency's tool to `path` for the
  ;; build. A Dojo build writes nothing outside itself, so the build's scripts
  ;; name the dependency's tool instead.
  (each [_ f (ipairs (b:find b.src "*"))]
    (let [name (: f :match "[^/]+$")]
      (when (and (or (: name :match "^configure") (: name :match "^Makefile") (: name :match "^ltmain")
                     (: name :match "%.in$") (: name :match "%.am$") (: name :match "%.ac$")
                     (: name :match "%.m4$") (: name :match "%.mk$") (: name :match "%.sh$")
                     (: name :match "%.pl$") (: name :match "%.py$"))
                 (not (b:exists (b:join f "."))))
        (let [text (b:read f)
              escaped (pick-values 1 (: path :gsub "[%^%$%(%)%%%.%[%]%*%+%-%?]" "%%%0"))
              (fixed n) (: text :gsub escaped (pick-values 1 (: replacement :gsub "%%" "%%%%")))]
          (when (> n 0) (b:write f fixed)))))))
{:name "sudo"
 :origin "karate"
 :version "1.8.18p1"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["ISC"]
 :description "Execute a command as another user"
 :upstream_url "https://www.sudo.ws/"
 :source {:url "ftp://ftp.sudo.ws/pub/sudo/sudo-1.8.18p1.tar.gz" :sha256 "e5a0471c721281a693025bbde33ebd9d3db43245d83ab8516bbfc23980379434"}
 :deps ["karate/coreutils" "karate/glibc" "karate/vim"]
 :build_deps ["karate/diffutils" "karate/file" "karate/gcc" "karate/make"]
 :bin_dirs ["bin" "sbin"]
 :include_dirs ["include"]
 :prepare (fn [b]
          (use-dependency-path b "/usr/bin/file" (b:path_for "file" "bin/file"))
          (var v-mvprog (.. (b:path_for "coreutils") "/bin/mv"))
          (b:env "MVPROG" v-mvprog)
          (var v-viprog (.. (b:path_for "vim") "/bin/vi"))
          (b:env "VIPROG" v-viprog))
 :build (fn [b]
          (b:run ["./configure" (.. "--prefix=" b.prefix) (.. "--with-editor=" (or (b:getenv "VIPROG") "")) "--with-env-editor"])
          (b:run ["make"]))
 :check (fn [b]
          (b:run ["chown" "root:root" "plugins/sudoers/regress/testsudoers/test3.d/root"])
          (b:run ["make" "check"]))
 :strip (fn [b]
          (b.default.strip b)
          ;; From do_end.
          )}
