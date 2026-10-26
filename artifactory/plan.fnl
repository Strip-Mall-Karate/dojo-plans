;; artifactory, ported from its plan.sh.
{:name "artifactory"
 :origin "karate"
 :version "6.9.0"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["JFrog Artifactory EULA"]
 :description "Artifactory is an advanced binary repository manager for use by build tools (like Maven and Gradle), dependency management tools (like Ivy and NuGet) and build servers (like Jenkins, Hudson, TeamCity and Bamboo).\nRepository managers serve two purposes: they act as highly configurable proxies between your organization and external repositories and they also provide build servers with a deployment destination for your internally generated artifacts."
 :upstream_url "https://www.jfrog.com/artifactory/"
 :source {:url "https://bintray.com/jfrog/artifactory/download_file?file_path=jfrog-artifactory-oss-6.9.0.zip" :sha256 "10a1a5caa24b3a8d76b34b9696cf6577ef48c36c806b41802b0b12586b70a6c3"}
 :deps ["karate/bash" "karate/jre8"]
 :svc {:user "root"}
 :exports {"port" "port"}
 :exposes ["port"]
 :build (fn [b]
          (b:fix_interpreter [(b:join b.src "bin/artifactory.sh")] "karate/bash" "bin/bash"))
 :install (fn [b]
          (b:log (.. "Copying files from " b.src))
          (each [_ p (ipairs (b:glob (.. b.cache "/" b.name "-oss-" b.version) "*"))] (b:copy p (b:join (.. (or (b:getenv "PREFIX") "") "/") (: p :match "[^/]+$")))))}
