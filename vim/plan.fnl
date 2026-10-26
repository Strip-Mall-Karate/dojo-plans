;; vim, ported from its plan.sh.
;; vim 9.2.1245 (the newest tag; vim's tags are its releases), the latest release on 2026-10-26.
{:name "vim"
 :origin "karate"
 :version "9.2.1245"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["Vim"]
 :description "Vim is a highly configurable text editor built to make creating and changing any kind of text very efficient. It is included as vi with most UNIX systems and with Apple OS X."
 :upstream_url "http://www.vim.org/"
 :source {:url "https://github.com/vim/vim/archive/refs/tags/v9.2.1245.tar.gz" :sha256 "4238a92338251c1ef9da0a2e0d3ebfa21e723038687d75878e964d64ff51e13d" :filename "vim-9.2.1245.tar.gz"}
 :deps ["karate/acl" "karate/attr" "karate/glibc" "karate/ncurses"]
 :build_deps ["karate/coreutils" "karate/diffutils" "karate/patch" "karate/make" "karate/gcc" "karate/sed" "karate/autoconf"]
 :bin_dirs ["bin"]
 :prepare (fn [b]
          (b:run ["autoconf"] {:cwd "src"})
          (b:env "CPPFLAGS" (.. (or (b:getenv "CPPFLAGS") "") " " (or (b:getenv "CFLAGS") "") " -O2"))
          (b:log (.. "Setting CPPFLAGS=" (or (b:getenv "CPPFLAGS") ""))))
 :build (fn [b]
          (b:run ["./configure" (.. "--prefix=" b.prefix) (.. "--with-compiledby=Dojo, vim release " b.version) "--with-features=huge" "--enable-acl" "--with-x=no" "--disable-gui" "--enable-multibyte"])
          (b:run ["make"]))
 :install (fn [b]
          (b.default.install b)
          (let [link (if (b:exists (b:join (.. b.prefix "/bin/vi") ".")) (b:join (.. b.prefix "/bin/vi") "vim") (.. b.prefix "/bin/vi"))]
            (b:symlink "vim" link))
          ;; The example scripts under tools name interpreters by their paths on other systems
          ;; (nawk, csh, python); they are documentation, not commands.
          (each [_ runtime (ipairs (b:glob (.. b.prefix "/share/vim") "vim*"))]
            (let [tools (b:join runtime "tools")]
              (when (b:exists tools)
                (each [_ f (ipairs (b:find tools "*"))]
                  (when (not (b:exists (b:join f ".")))
                    (b:chmod f "644"))))))
          (b:copy (b:join b.src "runtime/doc/uganda.txt") (.. b.prefix "/share/licenses/license.txt"))
          (b:chmod (.. b.prefix "/share/licenses/license.txt") "644"))}
