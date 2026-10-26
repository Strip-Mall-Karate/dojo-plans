;; attr, ported from its plan.sh.
{:name "attr"
 :origin "karate"
 :version "2.4.48"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["GPL-2.0"]
 :description "Commands for Manipulating Filesystem Extended Attributes"
 :upstream_url "https://savannah.nongnu.org/projects/attr/"
 :source {:url "http://download.savannah.gnu.org/releases/attr/attr-2.4.48.tar.gz" :sha256 "5ead72b358ec709ed00bbf7a9eaef1654baad937c001c044fe8b74c57f5324e7"}
 :deps ["karate/glibc"]
 :build_deps ["karate/coreutils" "karate/diffutils" "karate/make" "karate/gcc" "karate/gettext"]
 :bin_dirs ["bin"]
 :lib_dirs ["lib"]
 :include_dirs ["include"]
 :install (fn [b]
          (b:run ["make" "install"]))}
