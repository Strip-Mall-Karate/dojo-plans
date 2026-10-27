;; wal-e, ported from its plan.sh.
{:name "wal-e"
 :origin "karate"
 :version "1.1.0"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["wal-e license"]
 :description "Continuous Archiving for Postgres"
 :upstream_url "https://github.com/wal-e/wal-e"
 :source {:url "https://github.com/wal-e/wal-e/archive/v1.1.0.tar.gz" :sha256 "d3478e6eb4bfe00ac696af3e7ded4a91a0a2db6f9aa1a51ce780e43e4c12d6c7"}
 :deps ["karate/envdir" "karate/lzop" "karate/pv" "karate/python"]
 :bin_dirs ["bin"]
 :download (fn [b]
          nil)
 :verify (fn [b]
          nil)
 :unpack (fn [b]
          nil)
 :prepare (fn [b]
          (b:run ["python3" "-m" "venv" b.prefix])
          (b:env "VIRTUAL_ENV" (: (.. b.prefix "/bin/activate") :gsub "/bin/activate$" ""))
          (b:env "PATH" (.. (: (.. b.prefix "/bin/activate") :gsub "/bin/activate$" "") "/bin:" (or (b:getenv "PATH") ""))))
 :build (fn [b]
          nil)
 :install (fn [b]
          (b:run ["pip" "install" (.. "wal-e[aws]==" b.version)])
          (b:write (.. b.prefix "/requirements.txt") (.. (b:capture ["pip" "freeze"]) "\n")))}
