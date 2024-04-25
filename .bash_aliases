function diff_ss() {
    diff -yw "$1" "$2" | colordiff | /usr/share/doc/git/contrib/diff-hig>
}

function diff_out(){
    diff -uw "$1" "$2"| colordiff | /usr/share/doc/git/contrib/diff-high>
}
