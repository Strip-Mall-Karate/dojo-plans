;; liberation-fonts-ttf, ported from its plan.sh.
{:name "liberation-fonts-ttf"
 :origin "karate"
 :version "2.00.1"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["OFL-1.1"]
 :description "The Liberation Fonts are intended to be replacements for the three most commonly used fonts on Microsoft systems: Times New Roman, Arial, and Courier New."
 :upstream_url "https://pagure.io/liberation-fonts"
 :source {:url "https://releases.pagure.org/liberation-fonts/liberation-fonts-ttf-2.00.1.tar.gz" :sha256 "7890278a6cd17873c57d9cd785c2d230d9abdea837e96516019c5885dd271504"}
 :deps ["karate/fontconfig"]
 :build (fn [b]
          nil)
 :install (fn [b]
          (each [_ p (ipairs (b:glob b.src "*ttf"))] (b:move p (b:join (.. b.prefix "/") (: p :match "[^/]+$")))))}
