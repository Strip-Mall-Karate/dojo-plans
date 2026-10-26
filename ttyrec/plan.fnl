;; ttyrec, ported from its plan.sh.
{:name "ttyrec"
 :origin "karate"
 :version "1.0.8"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["bsd"]
 :description "ttyrec is a tty recorder. Recorded data can be played back with the included ttyplay command. ttyrec is just a derivative of script command for recording timing information with microsecond accuracy as well. It can record emacs -nw, vi, lynx, or any programs running on tty."
 :upstream_url "http://0xcc.net/ttyrec/"
 :source {:url "http://0xcc.net/ttyrec/ttyrec-1.0.8.tar.gz" :sha256 "ef5e9bf276b65bb831f9c2554cd8784bd5b4ee65353808f82b7e2aef851587ec"}
 :deps ["karate/glibc"]
 :build_deps ["karate/coreutils" "karate/make" "karate/gcc"]
 :bin_dirs ["bin"]
 :build (fn [b]
          (b:run ["make" "CFLAGS+=-DSVR4 -DHAVE_inotify -D_XOPEN_SOURCE=500"]))
 :install (fn [b]
          (each [_ v-bin (ipairs ["ttyplay" "ttyrec" "ttytime"])]
            (b:copy (if (= (: v-bin :sub 1 1) "/") v-bin (b:join b.src v-bin)) (.. b.prefix "/bin/" v-bin)) (b:chmod (.. b.prefix "/bin/" v-bin) "755")))}
