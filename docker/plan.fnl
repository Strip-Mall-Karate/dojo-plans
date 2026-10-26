;; docker, ported from its plan.sh.
{:name "docker"
 :origin "karate"
 :version "18.03.0"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["Apache-2"]
 :description "The Docker Engine"
 :upstream_url "https://docs.docker.com/engine/installation/binaries/"
 :source {:url "https://download.docker.com/linux/static/stable/x86_64/docker-18.03.0-ce.tgz" :sha256 "e5dff6245172081dbf14285dafe4dede761f8bc1750310156b89928dbf56a9ee" :dirname "docker"}
 :bin_dirs ["bin"]
 :build (fn [b]
          nil)
 :install (fn [b]
          (each [_ p (ipairs (b:glob b.src "docker*"))]
            (let [v-bin (: p :match "[^/]+$")]
              (b:copy (if (= (: v-bin :sub 1 1) "/") v-bin (b:join b.src v-bin)) (.. b.prefix "/bin/" v-bin)) (b:chmod (.. b.prefix "/bin/" v-bin) "755"))))
 :strip (fn [b]
          nil)}
