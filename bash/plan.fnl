;; bash, ported from its plan.sh.
;; bash 5.3.20, the latest release on 2026-10-26.
(var v-p "")
{:name "bash"
 :origin "karate"
 :version "5.3.20"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["gplv3+"]
 :description "Bash is the GNU Project's shell. Bash is the Bourne Again SHell. Bash is an sh-compatible shell that incorporates useful features from the Korn shell (ksh) and C shell (csh). It is intended to conform to the IEEE POSIX P1003.2/ISO 9945.2 Shell and Tools standard. It offers functional improvements over sh for both programming and interactive use. In addition, most sh scripts can be run by Bash without modification."
 :upstream_url "http://www.gnu.org/software/bash/bash.html"
 :source {:url "https://ftp.gnu.org/gnu/bash/bash-5.3.tar.gz" :sha256 "0d5cd86965f869a26cf64f4b71be7b96f90a3ba8b3d74e27e8e9d9d5550f31ba" :dirname "bash-5.3"}
 :deps ["karate/glibc" "karate/ncurses" "karate/readline"]
 :build_deps ["karate/coreutils" "karate/diffutils" "karate/patch" "karate/make" "karate/gcc"]
 :bin_dirs ["bin"]
 :interpreters ["bin/bash" "bin/sh"]
 :download (fn [b]
          ;; From do_begin.
          ;; The values bash-patches.sh set, read when the plan was ported.
          (b.default.download b)
          (let [v--patch-filess ["https://ftp.gnu.org/gnu/bash/bash-5.3-patches/bash53-001" "https://ftp.gnu.org/gnu/bash/bash-5.3-patches/bash53-002" "https://ftp.gnu.org/gnu/bash/bash-5.3-patches/bash53-003" "https://ftp.gnu.org/gnu/bash/bash-5.3-patches/bash53-004" "https://ftp.gnu.org/gnu/bash/bash-5.3-patches/bash53-005" "https://ftp.gnu.org/gnu/bash/bash-5.3-patches/bash53-006" "https://ftp.gnu.org/gnu/bash/bash-5.3-patches/bash53-007" "https://ftp.gnu.org/gnu/bash/bash-5.3-patches/bash53-008" "https://ftp.gnu.org/gnu/bash/bash-5.3-patches/bash53-009" "https://ftp.gnu.org/gnu/bash/bash-5.3-patches/bash53-010" "https://ftp.gnu.org/gnu/bash/bash-5.3-patches/bash53-011" "https://ftp.gnu.org/gnu/bash/bash-5.3-patches/bash53-012" "https://ftp.gnu.org/gnu/bash/bash-5.3-patches/bash53-013" "https://ftp.gnu.org/gnu/bash/bash-5.3-patches/bash53-014" "https://ftp.gnu.org/gnu/bash/bash-5.3-patches/bash53-015" "https://ftp.gnu.org/gnu/bash/bash-5.3-patches/bash53-016" "https://ftp.gnu.org/gnu/bash/bash-5.3-patches/bash53-017" "https://ftp.gnu.org/gnu/bash/bash-5.3-patches/bash53-018" "https://ftp.gnu.org/gnu/bash/bash-5.3-patches/bash53-019" "https://ftp.gnu.org/gnu/bash/bash-5.3-patches/bash53-020"] v--patch-shasumss ["1f608434364af86b9b45c8b0ea3fb3b165fb830d27697e6cdfc7ac17dee3287f" "e385548a00130765ec7938a56fbdca52447ab41fabc95a25f19ade527e282001" "f245d9c7dc3f5a20d84b53d249334747940936f09dc97e1dcb89fc3ab37d60ed" "9591d245045529f32f0812f94180b9d9ce9023f5a765c039b852e5dfc99747d0" "cca1ef52dbbf433bc98e33269b64b2c814028efe2538be1e2c9a377da90bc99d" "29119addefed8eff91ae37fd51822c31780ee30d4a28376e96002706c995ff10" "c0976bbfffa1453c7cfdd62058f206a318568ff2d690f5d4fa048793fa3eb299" "097cd723cbfb8907674ac32214063a3fd85282657ec5b4e544d2c0f719653fb4" "eee30fe78a4b0cb2fe20e010e00308899cfc613e0774ebb3c8557a1552f24f8c" "cf76f1cce2ea300c18bff9f002d21f280cc931acd17c28518110b93fe6e72569" "0298df8f5ea2a31d3be43ed7d269c5b3c7c342dd5b570bea7f64d66dcbbe7531" "d71379b39bebaedaf123414414e77fb458a0a43b9ad3116594c6df7ca6754573" "042f9cda967e24bf4211944697441e93d06ff42b4b998629a98a1b249279f200" "bd4360b401d38507e358783dcad8536a99c6789f0d3a5bd0cfb8c4a34144696c" "55b79ceee2fc27f6767eed697e939a7eb2fe2a28c01556bd75f18d581014f46e" "9ea29b266b7d24cb34d0ff3f1c4631e4d527bfe2d1ef15d17cdb924bf31ef767" "443b927b45c1558ca72052410f8b8f6e5152b617ed707061a2781d4375b0d1c3" "ae715d76c50341d7d7095e9a8d2eeed1ca9546152c2ac7289206f90cf30ac697" "a25c581e4d0057dea3833918438a930e2e86ee4c6dc17fe15267b7f04cbc4e3d" "df217ed3a9122aa2286d9b67bbe348661b6a9db262b580c29150dae55d532896"]]
            (for [n 1 20]
              (set v-p (. v--patch-filess n)) (b:download v-p (. v--patch-shasumss n) (: (: v-p :gsub "/+$" "") :match "[^/]*$"))))
          (set v-p ""))
 :verify (fn [b]
          (b.default.verify b)
          (let [v--patch-filess ["https://ftp.gnu.org/gnu/bash/bash-5.3-patches/bash53-001" "https://ftp.gnu.org/gnu/bash/bash-5.3-patches/bash53-002" "https://ftp.gnu.org/gnu/bash/bash-5.3-patches/bash53-003" "https://ftp.gnu.org/gnu/bash/bash-5.3-patches/bash53-004" "https://ftp.gnu.org/gnu/bash/bash-5.3-patches/bash53-005" "https://ftp.gnu.org/gnu/bash/bash-5.3-patches/bash53-006" "https://ftp.gnu.org/gnu/bash/bash-5.3-patches/bash53-007" "https://ftp.gnu.org/gnu/bash/bash-5.3-patches/bash53-008" "https://ftp.gnu.org/gnu/bash/bash-5.3-patches/bash53-009" "https://ftp.gnu.org/gnu/bash/bash-5.3-patches/bash53-010" "https://ftp.gnu.org/gnu/bash/bash-5.3-patches/bash53-011" "https://ftp.gnu.org/gnu/bash/bash-5.3-patches/bash53-012" "https://ftp.gnu.org/gnu/bash/bash-5.3-patches/bash53-013" "https://ftp.gnu.org/gnu/bash/bash-5.3-patches/bash53-014" "https://ftp.gnu.org/gnu/bash/bash-5.3-patches/bash53-015" "https://ftp.gnu.org/gnu/bash/bash-5.3-patches/bash53-016" "https://ftp.gnu.org/gnu/bash/bash-5.3-patches/bash53-017" "https://ftp.gnu.org/gnu/bash/bash-5.3-patches/bash53-018" "https://ftp.gnu.org/gnu/bash/bash-5.3-patches/bash53-019" "https://ftp.gnu.org/gnu/bash/bash-5.3-patches/bash53-020"] v--patch-shasumss ["1f608434364af86b9b45c8b0ea3fb3b165fb830d27697e6cdfc7ac17dee3287f" "e385548a00130765ec7938a56fbdca52447ab41fabc95a25f19ade527e282001" "f245d9c7dc3f5a20d84b53d249334747940936f09dc97e1dcb89fc3ab37d60ed" "9591d245045529f32f0812f94180b9d9ce9023f5a765c039b852e5dfc99747d0" "cca1ef52dbbf433bc98e33269b64b2c814028efe2538be1e2c9a377da90bc99d" "29119addefed8eff91ae37fd51822c31780ee30d4a28376e96002706c995ff10" "c0976bbfffa1453c7cfdd62058f206a318568ff2d690f5d4fa048793fa3eb299" "097cd723cbfb8907674ac32214063a3fd85282657ec5b4e544d2c0f719653fb4" "eee30fe78a4b0cb2fe20e010e00308899cfc613e0774ebb3c8557a1552f24f8c" "cf76f1cce2ea300c18bff9f002d21f280cc931acd17c28518110b93fe6e72569" "0298df8f5ea2a31d3be43ed7d269c5b3c7c342dd5b570bea7f64d66dcbbe7531" "d71379b39bebaedaf123414414e77fb458a0a43b9ad3116594c6df7ca6754573" "042f9cda967e24bf4211944697441e93d06ff42b4b998629a98a1b249279f200" "bd4360b401d38507e358783dcad8536a99c6789f0d3a5bd0cfb8c4a34144696c" "55b79ceee2fc27f6767eed697e939a7eb2fe2a28c01556bd75f18d581014f46e" "9ea29b266b7d24cb34d0ff3f1c4631e4d527bfe2d1ef15d17cdb924bf31ef767" "443b927b45c1558ca72052410f8b8f6e5152b617ed707061a2781d4375b0d1c3" "ae715d76c50341d7d7095e9a8d2eeed1ca9546152c2ac7289206f90cf30ac697" "a25c581e4d0057dea3833918438a930e2e86ee4c6dc17fe15267b7f04cbc4e3d" "df217ed3a9122aa2286d9b67bbe348661b6a9db262b580c29150dae55d532896"]]
            (for [n 1 20]
              nil)))
 :prepare (fn [b]
          (b.default.prepare b)
          (each [_ v-p (ipairs ["https://ftp.gnu.org/gnu/bash/bash-5.3-patches/bash53-001" "https://ftp.gnu.org/gnu/bash/bash-5.3-patches/bash53-002" "https://ftp.gnu.org/gnu/bash/bash-5.3-patches/bash53-003" "https://ftp.gnu.org/gnu/bash/bash-5.3-patches/bash53-004" "https://ftp.gnu.org/gnu/bash/bash-5.3-patches/bash53-005" "https://ftp.gnu.org/gnu/bash/bash-5.3-patches/bash53-006" "https://ftp.gnu.org/gnu/bash/bash-5.3-patches/bash53-007" "https://ftp.gnu.org/gnu/bash/bash-5.3-patches/bash53-008" "https://ftp.gnu.org/gnu/bash/bash-5.3-patches/bash53-009" "https://ftp.gnu.org/gnu/bash/bash-5.3-patches/bash53-010" "https://ftp.gnu.org/gnu/bash/bash-5.3-patches/bash53-011" "https://ftp.gnu.org/gnu/bash/bash-5.3-patches/bash53-012" "https://ftp.gnu.org/gnu/bash/bash-5.3-patches/bash53-013" "https://ftp.gnu.org/gnu/bash/bash-5.3-patches/bash53-014" "https://ftp.gnu.org/gnu/bash/bash-5.3-patches/bash53-015" "https://ftp.gnu.org/gnu/bash/bash-5.3-patches/bash53-016" "https://ftp.gnu.org/gnu/bash/bash-5.3-patches/bash53-017" "https://ftp.gnu.org/gnu/bash/bash-5.3-patches/bash53-018" "https://ftp.gnu.org/gnu/bash/bash-5.3-patches/bash53-019" "https://ftp.gnu.org/gnu/bash/bash-5.3-patches/bash53-020"])]
            (b:log (.. "Applying patch " (: (: v-p :gsub "/+$" "") :match "[^/]*$"))) (b:run ["patch" "-p0" "-i" (.. b.cache "/" (: (: v-p :gsub "/+$" "") :match "[^/]*$"))])))
 :build (fn [b]
          (b:run ["./configure" (.. "--prefix=" b.prefix) "--with-curses" "--enable-readline" "--without-bash-malloc" (.. "--with-installed-readline=" (b:path_for "readline"))])
          (b:run ["make"]))
 :check (fn [b]
          (var v-clean-cmds "")
          (set v-clean-cmds [])
          (each [_ v-cmd (ipairs ["/bin/rm" "/bin/cat" "/bin/touch" "/bin/chmod" "/usr/bin/printf" "/bin/echo"])]
            (when (not (b:exists v-cmd))
            (let [link (if (b:exists (b:join v-cmd ".")) (b:join v-cmd (: (.. (b:path_for "coreutils") "/bin/" (: (: v-cmd :gsub "/+$" "") :match "[^/]*$")) :match "[^/]+$")) v-cmd)]
            (b:symlink (.. (b:path_for "coreutils") "/bin/" (: (: v-cmd :gsub "/+$" "") :match "[^/]*$")) link)) (set v-clean-cmds [v-cmd])))
          (b:run ["make" "tests"])
          (each [_ v-cmd (ipairs v-clean-cmds)]
            (b:remove v-cmd)))
 :install (fn [b]
          (b.default.install b)
          (let [link (if (b:exists (b:join (.. b.prefix "/bin/sh") ".")) (b:join (.. b.prefix "/bin/sh") "bash") (.. b.prefix "/bin/sh"))]
            (b:symlink "bash" link)))}
