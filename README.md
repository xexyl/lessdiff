# lessdiff (version: 0.0.3-1):

The problem is simple to understand: when working in a desktop environment I
have many shells open (in KDE I use Konsole, under macOS I use the default
Terminal app) and I configure each tab to show the name of the currently
running process. But if it is more than one page of output I will need to
pipe it through a pager like 'less'. The latter part is perhaps even more
necessary when working at the console.

Anyway: when the diff is piped to less the tab will be called less: the
currently running process (though this is configurable I assume in the use
case that the tab is configured to the running process).

But I know I'm using a pager! It's far more convenient if I can see what the
original file/directory is all the more if I'm seeing pages of output or if
I am even looking at more than one diff (it happens!).

The variable LESSDIFF defines what diff to use; more specifically it defines
how to configure the invocation. You can set this in the alias for lessdiff
in e.g. your .bashrc file (or in macOS .bash_profile). I like coloured
output so I define LESSDIFF to be /usr/bin/colordiff (see below) (or
whatever path it is in your system).

The variable LESSDIFF_DIFF is the default diff i.e. /usr/bin/diff. This is
used to detect if LESSDIFF is diff (that is "${LESSDIFF_DIFF}" itself (which
would break the script) as well as making it possible to redefine the
default diff (much like the example below where I redefine LESSDIFF to be
/usr/bin/colordiff). If LESSDIFF_DIFF is the same value as LESSDIFF then
LESSDIFF is cleared which means it uses the unfiltered version of the
function.

The variable LESSDIFF_LESS is the pager (and options) to pipe the output of
the diff to the pager. By default it's '/usr/bin/less -r'. Note that the -r
option says that it should print raw control codes. This is important for
colours but the caveat is that it could cause display problems. To get round
this problem you could have a different alias e.g. lessdiff_colour and
lessdiff but all my uses this is not necessary.


# EXAMPLES

The following:

	alias lessdiff='LESSDIFF=/usr/bin/colordiff lessdiff'

aliases the diff (that overrides that is what the default i.e. LESSDIFF_DIFF
output is piped to LESSDIFF) to be /usr/bin/colordiff. This translates to:

	LESSDIFF=/usr/bin/colordiff lessdiff

Which by default would equate to:

	/usr/bin/diff -r [...] | colordiff | /usr/bin/less -r

This would override the less options so e.g. it quits if there's only one
page of output:

	alias lessdiff='LESSDIFF=/usr/bin/colordiff  LESSDIFF_LESS="/usr/bin/less -rF" lessdiff'


The script tries its best to defend against LESSDIFF being LESSDIFF_DIFF. It
does this by stripping spaces and anything beyond from the variables
LESSDIFF_DIFF and LESSDIFF so that it's only the file name (binary). I do
not know if it detects every possible issue but at the very least it will
defend against both of these (note in the second that there is an option
specified for the LESSDIFF_DIFF variable):

	alias lessdiff='LESSDIFF=/usr/bin/colordiff LESSDIFF_DIFF="/usr/bin/colordiff" lessdiff'
	alias lessdiff='LESSDIFF="/usr/bin/diff -r" LESSDIFF_DIFF="/usr/bin/diff -r" lessdiff'

In these cases the LESSDIFF variable would be cleared: there would be no
filtering so it would run diff and pipe the output to the LESSDIFF_DIFF.


# Warning about LESSDIFF_LESS

The script does NOT guard against LESSDIFF_LESS not existing and it does NOT
check if it can be executed. The trouble is that this would require setting a
default LESS to reset it and at this time I am too tired after these changes to
fix this.


# Installation

If you have `make` just run as root (or use sudo):

```sh
make install
```

To 'install' otherwise put the file somewhere in your path. You will then have
access to lessdiff. Then as above if you make an alias you can customise it more
e.g. my example of colordiff.


# Portability

I do not know how portable the bash variable substitution is. At the same
time this is meant to be a bash script and to not rely on other utilities
like sed(1). It could be adapted to rely on sed and be more portable but I
haven't implemented that (well I did first but I wanted shellcheck(1) to not
complain).

Previously I used -v to determine if the shell variable is set but not all
bash versions (e.g. default bash in macOS) support that so now it uses -n.


# Licence

This is public domain; use however you wish. The only 'impressive' thing
here (and 'impressive' is a huge exaggeration) is the concept; the script
itself is very simple (though I comment on it). I would appreciate if you
keep the headers intact however. Thank you.
