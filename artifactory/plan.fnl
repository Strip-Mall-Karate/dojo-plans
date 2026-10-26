;; artifactory, ported from its plan.sh.
;; artifactory 6.23.42, the latest release of the 6.x series on 2026-10-26 (7.x is a different layout these hooks cannot run): 6.9.0's source no longer downloads.
{:name "artifactory"
 :origin "karate"
 :version "6.23.42"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["JFrog Artifactory EULA"]
 :description "Artifactory is an advanced binary repository manager for use by build tools (like Maven and Gradle), dependency management tools (like Ivy and NuGet) and build servers (like Jenkins, Hudson, TeamCity and Bamboo).\nRepository managers serve two purposes: they act as highly configurable proxies between your organization and external repositories and they also provide build servers with a deployment destination for your internally generated artifacts."
 :upstream_url "https://www.jfrog.com/artifactory/"
 :source {:url "https://releases.jfrog.io/artifactory/bintray-artifactory/org/artifactory/oss/jfrog-artifactory-oss/6.23.42/jfrog-artifactory-oss-6.23.42.zip" :sha256 "b7d152435df543ae50c6a0ff44208aead93ca4f1b47b6658b1825df6ddcc2292" :dirname "artifactory-oss-6.23.42"}
 :deps ["karate/bash" "karate/corretto8"]
 :svc {:user "root"}
 :exports {"port" "port"}
 :exposes ["port"]
 :build (fn [b]
          (b:fix_interpreter [(b:join b.src "bin/artifactory.sh")] "karate/bash" "bin/bash"))
 :install (fn [b]
          (b:log (.. "Copying files from " b.src))
          (each [_ p (ipairs (b:glob (.. b.cache "/" b.name "-oss-" b.version) "*"))] (b:copy p (b:join (.. (or (b:getenv "PREFIX") "") "/") (: p :match "[^/]+$")))))}
