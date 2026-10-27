;; swig, ported from its plan.sh.
{:name :swig
 :origin :karate
 :version :3.0.10
 :targets [:x86_64-linux]
 :maintainer "Strip Mall Karate Company"
 :license [:GPL-3.0]
 :description "Generate scripting interfaces to C/C++ code"
 :upstream_url "http://www.swig.org/"
 :source {:url "http://prdownloads.sourceforge.net/swig/swig-3.0.10.tar.gz"
          :sha256 :2939aae39dec06095462f1b95ce1c958ac80d07b926e48871046d17c0094f44c}
 :deps [:karate/gcc-libs :karate/glibc :karate/pcre]
 :build_deps [:karate/diffutils :karate/gcc :karate/make]
 :bin_dirs [:bin]
 :check (fn [b]
          (b:run [:make :check]))}
