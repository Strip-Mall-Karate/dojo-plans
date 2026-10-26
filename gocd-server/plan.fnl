;; gocd-server, ported from its plan.sh.
{:name "gocd-server"
 :origin "karate"
 :version "18.9.0"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["Apache-2.0"]
 :description "GoCD is an open source tool which is used in software development to help teams and organizations automate the continuous delivery (CD) of software."
 :upstream_url "https://www.gocd.org"
 :source {:url "https://download.gocd.org/binaries/18.9.0-7478/generic/go-server-18.9.0-7478.zip" :sha256 "6a9de3f9a5a726d19946e1154d326c625c51ab371fcce5427a5819cfe9f143b2" :filename "go-server-18.9.0-7478.zip" :dirname "go-server-18.9.0"}
 :deps ["karate/git" "karate/corretto8"]
 :bin_dirs ["bin"]
 :exports {"port" "port" "ssl-port" "ssl-port"}
 :exposes ["port" "ssl-port"]
 :build (fn [b]
          nil)
 :install (fn [b]
          (b:mkdir (.. b.prefix "/bin"))
          (each [_ p (ipairs (b:glob b.src "*"))] (b:copy p (b:join (.. b.prefix "/bin") (: p :match "[^/]+$"))))
          (b:move (.. b.prefix "/bin/LICENSE") (b:join (.. b.prefix "/") (: (.. b.prefix "/bin/LICENSE") :match "[^/]+$"))))}
