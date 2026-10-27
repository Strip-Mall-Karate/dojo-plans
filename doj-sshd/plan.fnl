;; doj-sshd, OpenSSH's server for an installed Dojo machine. Written by hand.
;; The Supervisor runs it as a service. Its host key is made on first start and kept in
;; the service's data directory; root logs in with a key and never with a password.
{:name :doj-sshd
 :origin :karate
 :version :0.1.0
 :targets [:x86_64-linux]
 :maintainer "Strip Mall Karate Company"
 :license [:MIT]
 :description "SSH server for a Dojo machine."
 :upstream_url "https://github.com/StripMallKarateCompany/dojo-plans"
 :deps [:karate/openssh :karate/busybox-static]
 ;; sshd binds port 22 and switches to the user who logs in, so the service runs as root.
 :svc {:user :root :group :root}
 :build (fn [b] nil)
 :install (fn [b] nil)}
