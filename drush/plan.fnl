;; drush, ported from its plan.sh.
{:name :drush
 :origin :karate
 :version :8
 :targets [:x86_64-linux]
 :maintainer "Strip Mall Karate Company"
 :license [:gplv2+]
 :description "Drush is a command line shell and Unix scripting interface for Drupal."
 :upstream_url "http://www.drush.org/en/master/"
 :deps [:karate/bash :karate/coreutils :karate/php :karate/which]
 :build_deps [:karate/composer]
 :bin_dirs [:bin/vendor/bin]
 :download (fn [b]
             nil)
 :verify (fn [b]
           nil)
 :unpack (fn [b]
           nil)
 :build (fn [b]
          (b:run [:composer :global :require "drush/drush:8.*"]))
 :install (fn [b]
            (each [_ p (ipairs (b:glob (.. (or (b:getenv :HOME) "") :/.composer)
                                       "*"))]
              (b:copy p (b:join (.. b.prefix :/bin/) (: p :match "[^/]+$"))))
            (b:fix_interpreter [(.. b.prefix :/bin/vendor/bin/drush)]
                               :karate/coreutils :bin/env)
            (b:fix_interpreter [(.. b.prefix :/bin/vendor/bin/drush.launcher)]
                               :karate/coreutils :bin/env)
            (b:fix_interpreter [(.. b.prefix :/bin/vendor/bin/drush.php)]
                               :karate/coreutils :bin/env))}
