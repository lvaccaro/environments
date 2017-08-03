#!/bin/bash


while [[ $# -gt 1 ]]
do
key="$1"
case $key in
    -u|--url)
    URL="$2"
    shift # past argument
    ;;
    -s|--search)
    SEARCH="$2"
    shift # past argument
    ;;
    -f|--filter)
    FILTER="$2"
    shift # past argument
    ;;
    --default)
	SHOWHELP=true
    ;;
    *)
      SHOWHELP=true
    ;;
esac
shift # past argument or value
done

if [[ $# -eq 1 ]]
then
	SHOWHELP=true
fi

if [[ -n "$SHOWHELP" ]]; then

	echo -e "tweet-dl : download tweet and render as plain text"
	echo -e "OPTIONS:"
	echo -e "\t-u, --url\tUrl of the tweet"
	echo -e "\t-s, --search\tSearch by word/hashtag and render the 1st tweet"
	echo -e "\t-f, --filter\tFilter on search: default=populars, tweets=lasts, users=users, images=photos, videos=videos, news=news, broadcasts=broadcasts"
	exit
fi

if [[ -n "$SEARCH" ]]; then

	if [[ -z "$FILTER" ]]; then
		URL="https://twitter.com/search?q=$SEARCH&src=typd"	
	else
		URL="https://twitter.com/search?q=$SEARCH&src=typd&f=$FILTER"
	fi
	PAGE=$(curl "$URL" 2> /dev/null)
	URL=$( echo $PAGE | awk -F'data-permalink-path=| data-conversation-id=' '{print $2}')
	URL=$(echo $URL | sed "s/\"//g")
	URL="https://twitter.com/$URL"
fi

PAGE=$(curl $URL 2> /dev/null)
TEXT=$(echo $PAGE | awk -F'<title>|</title>' '{print $2}'  | xargs | recode html..ascii)
TIME=$(echo $PAGE | awk -F'class="tweet-timestamp js-permalink js-nav js-tooltip" title=| data-conversation-id=' '{print $3}' )
TIME=$(echo $TIME | sed "s/\"//g")

echo $URL
echo $TEXT
echo $TIME
