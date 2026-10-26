# fping

  fping is a program to send ICMP echo probes to network hosts, similar to
  ping, but much better performing when pinging multiple hosts. fping has a
  long long story: Roland Schemers did publish a first version of it in 1992
  and it has established itself since then as a standard tool.

## Maintainers

* Strip Mall Karate Company

## Type of Package

Binary package

## Usage

This package needs the file `/etc/protocols` from the `karate/iana-etc` package.
Add this to your plan/hooks:

```
if [[ ! -f /etc/protocols ]]; then
  doj pkg install karate/iana-etc
  ln -s $(doj pkg path karate/iana-etc)/etc/protocols /etc/protocols
fi
```
