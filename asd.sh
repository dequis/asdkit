#!/bin/sh
# enterprise asd system(tm)

DICT_FILE=~/.dict_asd
if [ ! -e ~/.dict_asd ]; then
    grep '^[a-z]\{4\}[a-z]*[^sd]$' /usr/share/dict/usa | grep -v '^.\{9\}.*$' | grep -v '[^aeiou]\{2\}' > $DICT_FILE
fi

word=$(shuf -n1 $DICT_FILE)

echo $word
[ -t 1 ] || echo $word >&2
[[ "$1" == "--noclipboard" ]] || echo -n $word | xclip -selection clipboard > /dev/null
