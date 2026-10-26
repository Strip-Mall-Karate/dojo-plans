# 7zip

7-Zip is a file archiver with a high compression ratio.

## Maintainers

Strip Mall Karate Company

## Type of Package

Binary package

## Usage

Install the package and execute 7zip.

On windows, `binlink` is not supported, so you can execute directly from the package:

```
doj pkg install karate/7zip
doj pkg exec karate/7zip 7z --help
```

On Linux you can do the same, or binlink and use the command directly:

```
doj pkg install karate/7zip --binlink
7z --help
```
