;; optipng, ported from its plan.sh.
{:name "optipng"
 :origin "karate"
 :version "0.7.7"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["Zlib"]
 :description "OptiPNG is a PNG optimizer that recompresses image files to a smaller size, without losing any information."
 :upstream_url "http://optipng.sourceforge.net/"
 :source {:url "http://prdownloads.sourceforge.net/optipng/optipng-0.7.7.tar.gz" :sha256 "4f32f233cef870b3f95d3ad6428bfe4224ef34908f1b42b0badf858216654452"}
 :build_deps ["karate/make" "karate/gcc" "karate/zlib"]
 :bin_dirs ["bin"]}
