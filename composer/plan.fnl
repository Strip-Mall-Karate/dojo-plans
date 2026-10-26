;; composer, ported from its plan.sh.
{:name "composer"
 :origin "karate"
 :version "1.8.0"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["MIT"]
 :description "Dependency Manager for PHP"
 :upstream_url "https://getcomposer.org/"
 :source {:url "https://getcomposer.org/download/1.8.0/composer.phar" :sha256 "0901a84d56f6d6ae8f8b96b0c131d4f51ccaf169d491813d2bcedf2a6e4cefa6" :filename "composer.phar"}
 :deps ["karate/php" "karate/git"]
 :bin_dirs ["bin"]
 :unpack (fn [b]
          nil)
 :build (fn [b]
          nil)
 :check (fn [b]
          (when (not (string.find (b:capture [(.. (b:path_for "karate/php") "/bin/php") "../composer.phar" "--version" "2>&1"]) (pick-values 1 (: b.version :gsub "[%^%$%(%)%%%.%[%]%*%+%-%?]" "%%%0")))) (error "grep -q ${pkg_version} found nothing")))
 :install (fn [b]
          (b:copy (b:join b.src "../composer.phar") (.. b.prefix "/bin/composer.phar"))
          (b:chmod (.. b.prefix "/bin/composer.phar") "755")
          (b:write (.. b.prefix "/bin/composer") (.. "#!/bin/sh\n\"" (b:path_for "karate/php") "\"/bin/php \"" b.prefix "/bin/composer.phar\" \"$@\"\n"))
          (b:chmod (.. b.prefix "/bin/composer") "+x"))}
