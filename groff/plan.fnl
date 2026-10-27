;; groff, ported from its plan.sh.
{:name :groff
 :origin :karate
 :version :1.22.3
 :targets [:x86_64-linux]
 :maintainer "Strip Mall Karate Company"
 :license [:GPL-3.0]
 :description "Groff (GNU troff) is a typesetting system that reads plain text mixed with formatting commands and produces formatted output. Output may be PostScript or PDF, html, or ASCII/UTF8 for display at the terminal. Formatting commands may be either low-level typesetting requests (“primitives”) or macros from a supplied set. Users may also write their own macros. All three may be combined."
 :upstream_url "https://www.gnu.org/software/groff/"
 :source {:url "http://ftp.gnu.org/gnu/groff/groff-1.22.3.tar.gz"
          :sha256 :3a48a9d6c97750bfbd535feeb5be0111db6406ddb7bb79fc680809cda6d828a5}
 :deps [:karate/gcc-libs]
 :build_deps [:karate/gcc :karate/gcc-libs :karate/make :karate/perl]
 :bin_dirs [:bin]}
