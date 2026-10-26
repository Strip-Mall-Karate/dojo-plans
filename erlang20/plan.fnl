;; erlang20, ported from its plan.sh.
;; Built from the erlang plan, with its own changes.
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
{:name "erlang20"
 :origin "karate"
 :version "20.2"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["Apache-2.0"]
 :description "A programming language for massively scalable soft real-time systems."
 :upstream_url "http://www.erlang.org/"
 :source {:url "http://www.erlang.org/download/otp_src_20.2.tar.gz" :sha256 "24d9895e84b800bf0145d6b3042c2f2087eb31780a4a45565206844b41eb8f23" :filename "otp_src_20.2.tar.gz" :dirname "otp_src_20.2"}
 :deps ["karate/glibc" "karate/zlib" "karate/ncurses" "karate/openssl" "karate/sed"]
 :build_deps ["karate/coreutils" "karate/gcc" "karate/make" "karate/openssl" "karate/perl" "karate/m4"]
 :bin_dirs ["bin"]
 :lib_dirs ["lib"]
 :include_dirs ["include"]
 :prepare (fn [b]
          (use-dependency-path b "/bin/pwd" (b:path_for "coreutils" "bin/pwd"))
          (use-dependency-path b "/bin/rm" (b:path_for "coreutils" "bin/rm")))
 :build (fn [b]
          (let [text (b:read (b:join b.src "erts/configure.in")) ends (= (text:sub -1) "\n") lines [] out []]
            (each [l (string.gmatch (if ends text (.. text "\n")) "(.-)\n")] (table.insert lines l))
            (each [n l (ipairs lines)]
              (var line l) (var deleted false) (local after [])
              (when (not deleted) (set line (pick-values 1 (string.gsub line "std_ssl_locations=.*" "std_ssl_locations=\"\"" 1))))
              (when (not deleted) (table.insert out line))
              (each [_ x (ipairs after)] (table.insert out x)))
            (b:write (b:join b.src "erts/configure.in") (.. (table.concat out "\n") (if (and ends (> (length out) 0)) "\n" ""))))
          (let [text (b:read (b:join b.src "erts/configure")) ends (= (text:sub -1) "\n") lines [] out []]
            (each [l (string.gmatch (if ends text (.. text "\n")) "(.-)\n")] (table.insert lines l))
            (each [n l (ipairs lines)]
              (var line l) (var deleted false) (local after [])
              (when (not deleted) (set line (pick-values 1 (string.gsub line "std_ssl_locations=.*" "std_ssl_locations=\"\"" 1))))
              (when (not deleted) (table.insert out line))
              (each [_ x (ipairs after)] (table.insert out x)))
            (b:write (b:join b.src "erts/configure") (.. (table.concat out "\n") (if (and ends (> (length out) 0)) "\n" ""))))
          (b:run ["./configure" (.. "--prefix=" b.prefix) "--enable-threads" "--enable-smp-support" "--enable-kernel-poll" "--enable-dynamic-ssl-lib" "--enable-shared-zlib" "--enable-hipe" (.. "--with-ssl=" (b:path_for "openssl")) (.. "--with-ssl-include=" (b:path_for "openssl") "/include") "--without-javac"] {:env {"CFLAGS" (.. (or (b:getenv "CFLAGS") "") " -O2")}})
          (b:run ["make"]))
 :strip (fn [b]
          (b.default.strip b)
          ;; From do_end.
          )}
