#!/bin/sh

TEXT=$(sh tweet-dl.sh -s "#bitcoin")
echo $TEXT
FIRST=$(echo "$TEXT" | head -n 1 )
LAST=$(echo -e "$TEXT" | tail -n 1 )
LINES=$(echo -e "$TEXT" | wc -l)
CONTENT=$(echo -e "$TEXT" | tail -n $(($LINES -1 )) | head -n $(($LINES -2 )) )
echo $FIRST - $CONTENT. $LAST | cowsay | lolcat

