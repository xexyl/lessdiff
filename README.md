# lessdiff

# What is `lessdiff(1)` and why might I want to use it?

The problem is simple to understand: when working in a desktop environment (or
actually at the console without a GUI at the server, though in that case I only
have one shell open that is visible at a time, and you won't see the name so
it's less useful but still useful at times) I have many shells open; in
[KDE](https://kde.org) I use [Konsole](https://konsole.kde.org), under
[macOS](https://www.apple.com/macos/) I use the default [Terminal
app](https://support.apple.com/en-gb/guide/terminal/welcome/mac) and in [Rocky
Linux](https://rockylinux.org) I use .. well the console (which again has
limited use for this but still not totally useless, even if one can just pipe it
through `less -r` or `less -R`).

Now it is **extremely helpful** to configure **each tab** to show the name of
the **currently running process** (in the console the name is not so useful,
obviously, as noted above, but this script is also only slightly useful at the
console). But if it is more than one page of output I very often will need to
pipe it through a pager like `less(1)` (for obvious reasons).  (The latter part
is perhaps even more necessary when working at the console, but then in that
case I won't see the command - well maybe with `screen(1)` or `tmux(1)` but I
don't always use it - but it's always useful in a terminal application).

Anyway: when the `diff(1)` is piped to `less(1)` the tab will be called `less`:
the currently running process (though this is configurable, in my uses
the tab is configured to be named to the running process, which causes the
problem but allows for something much more useful[^0]).

But I know I'm using a pager! It's **far more convenient if I can see what the
_ORIGINAL_ command that I'm piping to `less(1)` is**, not the pager itself, and
all the more if I'm seeing pages of output or if I am even looking at more than
one `diff(1)` (which happens).

Thus many years back, when tired of this problem, I devised `lessdiff(1)` to
solve this problem. I improved it over the years; the original changelog, at
least up to 0.0.4-1, is, alas!, in the script comments, as I never had it as a
repo for some silly reason or another, but simply copied it over to my different
systems and in those days my only repos, all of which still exist, were on the
server and I never even dreamt I'd use GitHub; in fact I was certain I never
would). Nevertheless I have tried to make a changelog file that although is not
perfectly accurate will still give something of an idea. It is unclear if this
will be maintained but then again it's unlikely that this script will be changed
anyway.


# How to use

These sections explain how to use the tool.

## Environmental variables:

The variable `LESSDIFF` defines what `diff(1)` to use; more specifically it defines
how to configure the invocation. You can set this in the alias for `lessdiff`
in e.g. your `.bashrc` file (or in macOS `.bash_profile`[^1]). I like coloured
output so I define `LESSDIFF` to be `/usr/bin/colordiff` (see below) (or
whatever path it is in your system).

The variable `LESSDIFF_DIFF` is the default `diff` i.e. `/usr/bin/diff`. This is
used to detect if `LESSDIFF` is `diff` (that is `"${LESSDIFF_DIFF}"` itself,
which would break the script) as well as making it possible to redefine the
default `diff` (much like the example below where I redefine `LESSDIFF` to be
`/usr/bin/colordiff` as I always do). If `LESSDIFF_DIFF` is the same value as
`LESSDIFF` then `LESSDIFF` is cleared which means it uses the **unfiltered**
version of the function, `_lessdiff_unfiltered`.

The variable `LESSDIFF_LESS` is the **pager _and_ options** to pipe the output of
the `diff` (whatever `diff(1)` you want) to the pager. By default it's
`/usr/bin/less -r` (filtered `diff` for raw control chars).

### But why `-r` when the man page recommends against it, favouring `-R`?

Note that the `-r` option says that it should print raw control codes. This is
important for colours but the caveat is that it could cause display problems. To
get round this problem you could have a different alias e.g. `lessdiff_colour`
and `lessdiff` but all my uses this is not necessary. Nevertheless, one can
certainly use `-R` but this is not tested.


[^0]: This includes the fact I can use `colordiff(1)` which is incredibly
useful.

[^1]: Yes I know that the default shell in macOS has been for years now,
`zsh(1)` but I have never liked `zsh(1)`: far from it. This script has not even
been tested with `zsh(1)` and it almost certainly never will be either.

# Examples

These examples should, I hope, give you an idea how to use the tool.

The following:

```sh
alias lessdiff='LESSDIFF=/usr/bin/colordiff lessdiff'
```


aliases the `diff` (that overrides that is what the default i.e. `LESSDIFF_DIFF`
output is piped to `LESSDIFF`) to be `/usr/bin/colordiff`. This translates to:

```sh
LESSDIFF=/usr/bin/colordiff lessdiff
```

which by default would equate to:

```sh
/usr/bin/diff -r [...] | colordiff | /usr/bin/less -r
```

This would override the `less(1)` options so e.g. it quits if there's only one
page of output:

```sh
alias lessdiff='LESSDIFF=/usr/bin/colordiff  LESSDIFF_LESS="/usr/bin/less -rF" lessdiff'
```

The script tries its best to defend against `LESSDIFF` being `LESSDIFF_DIFF`. It
does this by stripping spaces and anything beyond from the variables
`LESSDIFF_DIFF` and `LESSDIFF` so that it's only the file name (binary).

This does **NOT** mean that it detects every possible issue but at the very
least it will defend against both of these (note in the second one below that
there is an option specified for the `LESSDIFF_DIFF` variable):

```sh
alias lessdiff='LESSDIFF=/usr/bin/colordiff LESSDIFF_DIFF="/usr/bin/colordiff" lessdiff'
alias lessdiff='LESSDIFF="/usr/bin/diff -r" LESSDIFF_DIFF="/usr/bin/diff -r" lessdiff'
```

In these cases the `LESSDIFF` variable would be cleared: there would be no
filtering so it would run `diff` and pipe the output to the `LESSDIFF_DIFF`.


## Example use:

For any example below (one, or if I add any later, all), I have `lessdiff`
aliased as:


```sh
alias lessdiff='LESSDIFF=/opt/local/bin/colordiff lessdiff'
```

as I am writing this with macOS and `colordiff` installed with MacPorts.

### `lessdiff README.md lessdiff`

This first example is quite contrived and would not normally be useful but it
shows the multi-paged output.

```sh
lessdiff README.md lessdiff
```

This will be quite a long output of a coloured `diff(1)` piped through `less`
but the tab will show, if configured correctly (which is outside the scope of
this document as it depends on what terminal application you are using), the
files diffed, rather than just `less`.


# Caveats and warnings:

Of course, depending on how you configure the terminal application, this might
not be useful and it might also not show helpful output. If it's not configured
to show the currently running process this is obviously useless.


## WARNING about `LESSDIFF_LESS`:

The script does **NOT** guard against `LESSDIFF_LESS` non existing tools (that
is your responsibility) and it does **NOT** check if it can be executed. The
trouble is that to fix this, at least as I have determined (since I last worked
on this, which is not the date I made this a repo) this would require setting a
default `LESS` to reset it and at this time (when I first started writing the
README.md which was quite some time back, not 25 July 2024 when I turned this
into a GitHub repo) I am too tired after these changes to fix this.


# Installation:

If you have `make` just run as root (or use sudo):

```sh
make install
```

To 'install' otherwise put the file somewhere in your path. You will then have
access to `lessdiff(1)`. Then as above if you make an alias you can customise it more
e.g. my example of `colordiff(1)`.


# Portability:

I do **NOT** know how portable the `bash(1)` variable substitution is. At the same
time this is meant to be a `bash(1)` (see footnote above about `zsh(1)`) script and
to not rely on other utilities like `sed(1)`. It could be adapted to rely on
`sed(1)` and be more portable but I haven't implemented that (well I did first
but I wanted `shellcheck(1)` to not whine about it).

Additionally I do not know if this will work with all versions of `bash(1)`; I
rather suspect it will not so this can be considered 'AS IS'. Of course if you
have any fixes I'd be more than happy to look at a pull request to make it more
portable, as long as it works in my versions of `bash(1)`.

Previously I used `-v` to determine if the shell variable (`LESSDIFF`) is set
but not all bash versions (e.g. default bash in macOS) support that so now it
uses `-n`.


# Licence:

This is public domain; use however you wish. The only 'impressive' thing here
(and **_'impressive'_ is a HUGE exaggeration!**) is the concept; the script
itself is very simple (though I comment on it). I would appreciate if you keep
the headers intact however. Thank you.
