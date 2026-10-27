;; ansible, ported from its plan.sh.
{:name :ansible
 :origin :karate
 :version :2.7.6
 :targets [:x86_64-linux]
 :maintainer "Strip Mall Karate Company"
 :license [:GPL-3.0]
 :description "Ansible is a radically simple IT automation platform that makes your applications and systems easier to deploy."
 :upstream_url "https://www.ansible.com/"
 :source {:url "https://github.com/ansible/ansible/archive/v2.7.6.tar.gz"
          :sha256 :f37b83e614ec1b004714456e99ed8cad66541e0739bd5765b71caa541c7f9861
          :filename :ansible-2.7.6.tar.gz}
 :deps [:karate/libffi :karate/python2 :karate/sshpass :karate/openssl]
 :build_deps [:karate/gcc :karate/libyaml :karate/make]
 :bin_dirs [:bin]
 :prepare (fn [b]
            ;; From do_setup_environment.
            (b:runtime_env_push :PYTHONPATH
                                (.. (b:path_for :python2)
                                    :/lib/python2.7/site-packages))
            (b:runtime_env_push :PYTHONPATH
                                (.. b.prefix :/lib/python2.7/site-packages))
            (b:runtime_env_push :ANSIBLE_CONFIG (.. b.prefix :/etc/ansible.cfg))
            (b:buildtime_env_push :LD_LIBRARY_PATH
                                  (.. (b:path_for :libffi) :/lib))
            (b:mkdir (.. b.prefix :/lib/python2.7/site-packages))
            (b:mkdir (.. b.prefix :/share))
            (b:mkdir (.. b.prefix :/etc)))
 :build (fn [b]
          (b:run [:python :setup.py :build]))
 :install (fn [b]
            (b:run [:python
                    :setup.py
                    :install
                    (.. :--prefix= b.prefix)
                    :--optimize=1
                    :--skip-build])
            (each [_ p (ipairs (b:glob (b:join b.src :examples) "*"))]
              (b:copy p (b:join (.. b.prefix :/share/) (: p :match "[^/]+$"))))
            (b:copy (b:join b.src :examples/ansible.cfg)
                    (.. b.prefix :/etc/ansible.cfg))
            (b:chmod (.. b.prefix :/etc/ansible.cfg) :644))}
