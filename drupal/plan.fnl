;; drupal, ported from its plan.sh.
{:name :drupal
 :origin :karate
 :version :8.3.2
 :targets [:x86_64-linux]
 :maintainer "Strip Mall Karate Company"
 :license [:gplv2+]
 :description "Drupal is a free and open source content-management framework written in PHP."
 :upstream_url "https://www.drupal.org"
 :deps [:karate/mysql-client :karate/drush :karate/nginx :karate/php]
 :svc {:run "php-fpm --nodaemonize" :user :root}
 :binds {:database [:port :username :password]}
 :build (fn [b]
          (b:run [:drush
                  :dl
                  :drupal-8.3.2
                  (.. :--destination= b.src)
                  :--drupal-project-rename=drupal]))
 :install (fn [b]
            (if (b:exists (.. b.prefix :/drupal))
                (b:copy (.. b.src :/drupal)
                        (b:join (.. b.prefix :/drupal)
                                (: (.. b.src :/drupal) :match "[^/]+$")))
                (b:copy (.. b.src :/drupal) (.. b.prefix :/drupal))))}
