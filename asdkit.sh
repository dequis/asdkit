#!/bin/bash

ASDROOT='/home/dx/test/asd'
THISDAMNFILE='/home/dx/test/asdkit'

ensure_root() {
    if [ $(realpath ${1:-.}) != "$ASDROOT" ]
    then
        echo "ensure_root failed"
        return 1
    fi
}

go_root() {
    cd $ASDROOT
}

get_random_file() {
    ls -1 | sort -R | head -n1
}

wait_for_confirmation() {
    echo 'enter to continue, ctrl-c to abort'
    read
}

nuke_this() {
    ensure_root .. || return 1
    if ! is_empty; then
        (summary) || echo summary failed
        echo
        wait_for_confirmation || return 1
    fi
    local dir=$PWD
    cd ..
    rm -rf $dir
    echo nuked $dir
}

enter_sneaky() {
    go_root
    local dir=${1:-$(get_random_file)}
    cd $dir || return 1
}

indent() {
    sed 's/^/    /'
}

is_empty() {
    local dir=${1:-.}
    return $(ls -A $dir | wc -l)
}

list_empty() {
    for i in $ASDROOT/*; do
        is_empty $i && echo $(basename $i)
    done
}

nuke_empty() {
    go_root
    local -a empty_dirs
    empty_dirs=($(list_empty))

    echo Empty dirs:
    echo "    "${empty_dirs[@]}

    wait_for_confirmation

    for i in $empty_dirs; do
        cd $i
        nuke_this
    done
}

summary() {
    if [ -e label ]; then
        echo "has label:"
        echo $(cat label) | indent
        echo 
    fi

    if is_empty; then
        echo "directory empty"
    else
        echo "ls:"
        local ls_out
        local file_out
        for i in *; do
            ls_out=$(ls -lhd --color=always $i 2>&1)
            file_out=$(file -b $i 2>&1 | head -c 30)
            printf "    %-30s | %-80s\n" $file_out $ls_out
        done
    fi
}

summary_with_du() {
    summary
    echo
    echo "du:"
    du -sh . 2>&1 | indent
}

enter() {
    enter_sneaky $1 || return 1
    summary_with_du
    thunar . 2>&1 >/dev/null &
}


label() {
    ensure_root .. || return 1
    echo $@ > label
    cd ..
}

list_labels() {
    for i in ./*/label; do
        echo $i = $(cat $i)
    done
}

fix_labels() {
    for i in ./*/label; do
        echo $(cat $i) > $i
        sed -i 's/[_ ]/-/g' $i
    done
}

move_this() {
    ensure_root .. || return 1
    local dir=$PWD
    cd ..
    mv -v $dir $1
    echo
    echo moved $dir to $1
}

summary_oneline() {
    local dir=${1:-.}
    if [ -e $dir/label ]; then
        cat $dir/label
    else
        if [ $(ls -1A $dir | wc -l) = 1 ]; then
            echo $(ls -1A $dir)
        else
            echo asd
        fi
    fi
}

lsasd() {
    local ls_out
    local summary
    for i in $(find . -maxdepth 1 -type d -printf "%T@ %p\n" | sort -n | sed 's/^[^ ]* //'); do
        ls_out=$(ls -lhd --color=always $i 2>&1)
        summary=$(summary_oneline $i | head -c20)
        printf "%-20s | %-80s\n" $summary $i
    done
}

asdkit() {
    if [ "x$1" = 'xhelp' ]; then
        echo "Useful commands:"
        echo "    go_root       (alias g)"
        echo "    enter         (alias e)"
        echo "    summary       (alias s)"
        echo "    label         (alias l)"
        echo "    nuke_this"
        echo "    nuke_empty"
        echo "    move_this"
        echo "    list_labels"
        echo "    list_empty"
        echo "    lsasd"
        echo
        echo "Other aliases:"
        echo "    gs = git status"
        echo
        echo "Other commands: ensure_root get_random_file enter_sneaky fix_labels"
        echo
        echo "Run 'asdkit' to reload"
        return 0
    fi

    # otherwise reload
    source $THISDAMNFILE
}

alias g=go_root
alias e=enter
alias s=summary
alias l=label
alias gs='git status'

echo "asdkit loaded"
echo "See 'asdkit help' for commands"
