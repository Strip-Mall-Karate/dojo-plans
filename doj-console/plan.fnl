;; doj-console, a login prompt on an installed Dojo machine's consoles. Written by hand.
;; The Supervisor runs it as a service: getty on the serial console and the first virtual
;; terminal, with busybox's login against /etc/passwd and /etc/shadow.
{:name :doj-console
 :origin :karate
 :version :0.1.0
 :targets [:x86_64-linux]
 :maintainer "Strip Mall Karate Company"
 :license [:MIT]
 :description "Console login for a Dojo machine."
 :upstream_url "https://github.com/StripMallKarateCompany/dojo-plans"
 :deps [:karate/busybox-static]
 ;; getty opens the terminals and login switches users, so the service runs as root.
 :svc {:user :root :group :root}
 :build (fn [_b] nil)
 :install (fn [_b] nil)}
