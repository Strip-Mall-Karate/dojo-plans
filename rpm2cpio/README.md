# Dojo package: rpm2cpio

## Description

Why does the world need another rpm2cpio?  Because the existing one won't build unless you have half a ton of things that aren't really required for it, since it uses the same library used to extract RPM's.

## Usage

Dumps the contents of an RPM to stdout as a GNU cpio archive

`doj pkg exec karate/rpm2cpio rpm2cpio RPM_FILE | cpio`

or

`doj pkg exec karate/rpm2cpio rpm2cpio < RPMFILE | cpio`

If required, there is a `karate/cpio` package available via `doj pkg install`.
