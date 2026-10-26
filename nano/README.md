# Nano

GNU nano -- an enhanced clone of the Pico text editor.

## Maintainers

* Strip Mall Karate Company

## Type of Package

Binary package

## Usage

```
doj pkg install karate/nano --binlink
nano
```

Or, execute from package without binlink:

```
doj pkg exec karate/nano nano
```

## Notes

Syntax highlighting files are distrubuted by default in the `${pkg_prefix}/share/nano/` directory. You can enable syntax highlighting by creating a `.nanorc` file in your user home directory, and including these files. Example: `include /doj/pkg/core/nano/2.9.8/0180702051038/share/nano/*.nanorc`.

Note, it might be simpler to symlink this directory somewhere for shorter paths / easier access, or use the doj helpers:

```
echo "include $(doj pkg path karate/nano)/share/nano/*.nanorc" > ~/.nanorc
```
