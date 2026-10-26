;; vim, ported from its plan.sh.
{:name "vim"
 :origin "karate"
 :version "8.1.0577"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["Vim"]
 :description "Vim is a highly configurable text editor built to make creating and changing any kind of text very efficient. It is included as vi with most UNIX systems and with Apple OS X."
 :upstream_url "http://www.vim.org/"
 :source {:url "http://github.com/vim/vim/archive/v8.1.0577.tar.gz" :sha256 "16a6a8590a36b9c114a2c4a171598a4d07ac9c214fb80bc490c76bfa7e6446dd"}
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
          (b:copy (b:join b.src "runtime/doc/uganda.txt") (.. b.prefix "/share/licenses/license.txt"))
          (b:chmod (.. b.prefix "/share/licenses/license.txt") "644"))}
