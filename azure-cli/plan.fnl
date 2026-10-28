;; azure-cli, ported from its plan.sh.
{:name :azure-cli
 :origin :karate
 :version :2.0.57
 :targets [:x86_64-linux]
 :maintainer "Strip Mall Karate Company"
 :license [:MIT]
 :description "The Azure command-line interface (CLI) is Microsoft's cross-platform command-line experience for managing Azure resources. Use it in your browser with Azure Cloud Shell, or install it on macOS, Linux, or Windows and run it from the command line."
 :upstream_url "https://docs.microsoft.com/en-us/cli/azure"
 :source {:url "https://github.com/Azure/azure-cli/archive/azure-cli-2.0.57.tar.gz"
          :sha256 :0777d6c301bf741a2fdf9d2053a3a9285a4e0f5a067b64659e77c1ca9ed71e7a
          :dirname :azure-cli-azure-cli-2.0.57}
 :deps [:karate/coreutils
        :karate/python
        :karate/openssl
        :karate/libffi
        :karate/bash
        :karate/glibc]
 :build_deps [:karate/gcc :karate/linux-headers :karate/util-linux]
 :bin_dirs [:bin]
 :prepare (fn [b]
            (b:run [:python :-m :venv b.prefix])
            (b:env :VIRTUAL_ENV
                   (: (.. b.prefix :/bin/activate) :gsub :/bin/activate$ ""))
            (b:env :PATH
                   (.. (: (.. b.prefix :/bin/activate) :gsub :/bin/activate$ "")
                       "/bin:" (or (b:getenv :PATH) "")))
            (b:run [:pip :install :--upgrade :--force-reinstall :pip])
            (b:run [:pip :install :wheel]))
 :build (fn [b]
          (local dirs
                 [:src/azure-cli
                  :src/azure-cli-telemetry
                  :src/azure-cli-core
                  :src/azure-cli-nspkg
                  :src/azure-cli-command_modules-nspkg])
          (each [_ m (ipairs (b:glob (b:join b.src :src/command_modules)
                                     :azure-cli-*))]
            (table.insert dirs m))
          (each [_ d (ipairs dirs)]
            (b:log (.. "Building " d))
            (b:run [:python :setup.py :bdist_wheel :-d (b:join b.src :_build)]
                   {:cwd d})))
 :install (fn [b]
            (var v-all-modules "")
            (set v-all-modules
                 (b:capture [:find
                             (.. b.cache :/azure-cli-azure-cli-2.0.57/_build)
                             :-name
                             :*.whl]))
            (b:run [:pip :install :--no-cache-dir v-all-modules])
            (b:run [:pip
                    :install
                    :--no-cache-dir
                    :--force-reinstall
                    :--upgrade
                    :azure-nspkg
                    :azure-mgmt-nspkg])
            (b:write (.. b.prefix :/requirements.txt)
                     (.. (b:capture [:pip :freeze]) "\n"))
            (b:fix_interpreter (b:glob (.. b.prefix :/bin) "*")
                               :karate/coreutils :bin/env))
 :strip (fn [_b]
          nil)}
