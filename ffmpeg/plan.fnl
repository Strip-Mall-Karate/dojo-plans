;; ffmpeg, ported from its plan.sh.
{:name "ffmpeg"
 :origin "karate"
 :version "3.3.2"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["LGPL-2.1+" "GPL-2.0+"]
 :description "A complete, cross-platform solution to record, convert and stream audio and video."
 :upstream_url "https://ffmpeg.org/"
 :source {:url "https://ffmpeg.org/releases/ffmpeg-3.3.2.tar.gz" :sha256 "84cf294b6b2115879f347ae74ab411876c4298e17d3a0db68a55338bb88fa594"}
 :deps ["karate/bzip2" "karate/glibc" "karate/gmp" "karate/libwebp" "karate/openjpeg" "karate/xz" "karate/zlib"]
 :build_deps ["karate/diffutils" "karate/gcc" "karate/make" "karate/pkg-config" "karate/yasm"]
 :bin_dirs ["bin"]
 :lib_dirs ["lib"]
 :include_dirs ["include"]
 :build (fn [b]
          (b:run ["./configure" (.. "--prefix=" b.prefix) "--disable-debug" "--disable-static" "--enable-avisynth" "--enable-avresample" "--enable-gmp" "--enable-gpl" "--enable-libopenjpeg" "--enable-libwebp" "--enable-shared" "--enable-version3"])
          (b:run ["make" (.. "-j" (tostring b.jobs))]))
 :check (fn [b]
          (b:run ["make" "check"]))}
