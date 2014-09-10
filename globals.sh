mkcdir() {
    mkdir $1
    cd $1
}

mkasd() {
    if [ "$1" != "-f" ]; then
        cd "$HOME/test/asd"
    fi
    mkcdir $(asd --noclipboard)
}

asdkit() {
    source /home/dx/test/asdkit
}

