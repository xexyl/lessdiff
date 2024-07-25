# CHANGES (since 19 Oct 2019):

   Last updated: 04 Feb 2023
   (Possibly original date: 25 Oct 2016)

# Script history (since 19 Oct 2019):

## 19/Oct/2019 (`lessdiff` version: 0.0.2-1)
- Make much more customisable: now the default `diff` as well as the less
invocation can be configured. `LESSDIFF_DIFF` Is the default `diff` and
`LESSDIFF_LESS` is the `less(1)` invocation.

- Defend against `LESSDIFF` being the same as the default `diff` (now in
`LESSDIFF_DIFF`).

- More documentation with examples etc.

## 03/Feb/2023 (lessdiff version: 0.0.3-1)

- Use `-n` instead of `-v` as not all bash versions support `-v`.


##  04/Feb/2023 (lessdiff version 0.0.4-1)

- Check that the number of args specified is two.
- Use `-r` for directories.

