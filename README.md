## asdkit

Semi-temporary directory management scripts

It helps you create a mess of directories with meaningless names, which is better than having a mess in $HOME

Just dumping this here to have it nicely versioned. May have hardcoded paths and stuff.

### Why

The idea is: I need to create some files, or fetch a git repo, or try anything
out, and I don't want to put them in a single messy directory, or stop even a
second to think about a name for what I'm about to do.

So I just type "mkasd", it creates a directory with a random name, and I start
putting stuff in there.

Eventually it became a mess, and I started getting errors saying that the
directory already exists. So asdkit.sh was born, to manage that mess.

### Dictionary

The dictionary is generated from /usr/share/dict/usa ("words" package), filtered
to include "simple" words. The actual code is in asd.sh, explanation:


Main filter:

    ^[a-z]{4}[a-z]*[^sd]$

    # breakdown:

    ^[a-z]{4}       # at least 4 letters
    [a-z]*          # the rest must be all letters too
    [^sd]$          # not ending with s (plural) or d (past verbs)
                    # mostly because these are the main redundancy

Exclusions:

    ^.{9}.*$        # avoid words longer than 9 chars

    [^aeiou]{2}     # avoid words that have two consonants together
                    # this ensures all words are "simple"
