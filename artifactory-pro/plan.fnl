;; artifactory-pro, ported from its plan.sh.
{:name :artifactory-pro
 :origin :karate
 :version :6.9.0
 :targets [:x86_64-linux]
 :maintainer "Strip Mall Karate Company"
 :license ["JFrog Artifactory EULA"]
 :description "Artifactory is an advanced binary repository manager for use by build tools (like Maven and Gradle), dependency management tools (like Ivy and NuGet) and build servers (like Jenkins, Hudson, TeamCity and Bamboo).
Repository managers serve two purposes: they act as highly configurable proxies between your organization and external repositories and they also provide build servers with a deployment destination for your internally generated artifacts."
 :upstream_url "https://www.jfrog.com/artifactory/"
 :source {:url "https://dl.bintray.com/jfrog/artifactory-pro/org/artifactory/pro/jfrog-artifactory-pro/6.9.0/jfrog-artifactory-pro-6.9.0.zip"
          :sha256 :6ae08f84f94b6a57305416144e8d71291ed9ffec9f845973b5412f4fd8aee1c3}
 :deps [:karate/bash :karate/corretto8]
 :svc {:user :root}
 :exports {:port :port}
 :exposes [:port]
 :build (fn [b]
          (b:fix_interpreter [(b:join b.src :bin/artifactory.sh)] :karate/bash
                             :bin/bash))
 :install (fn [b]
            (b:log (.. "Copying files from " b.src))
            (each [_ p (ipairs (b:glob b.src "*"))]
              (b:copy p (b:join (.. b.prefix "/") (p:match "[^/]+$")))))}
