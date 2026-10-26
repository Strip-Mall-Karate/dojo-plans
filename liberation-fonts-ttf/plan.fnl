;; liberation-fonts-ttf, ported from its plan.sh.
;; liberation-fonts-ttf 2.1.5, the latest release on 2026-10-26: 2.00.1's source no longer downloads.
{:name "liberation-fonts-ttf"
 :origin "karate"
 :version "2.1.5"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["OFL-1.1"]
 :description "The Liberation Fonts are intended to be replacements for the three most commonly used fonts on Microsoft systems: Times New Roman, Arial, and Courier New."
 :upstream_url "https://pagure.io/liberation-fonts"
 :source {:url "https://github.com/liberationfonts/liberation-fonts/files/7261482/liberation-fonts-ttf-2.1.5.tar.gz" :sha256 "7191c669bf38899f73a2094ed00f7b800553364f90e2637010a69c0e268f25d0"}
 :deps ["karate/fontconfig"]
 :build (fn [b]
          nil)
 :install (fn [b]
          (each [_ p (ipairs (b:glob b.src "*ttf"))] (b:move p (b:join (.. b.prefix "/") (: p :match "[^/]+$")))))}
