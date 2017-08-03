#!/bin/bash


urlencode() {
    # urlencode <string>
    old_lc_collate=$LC_COLLATE
    LC_COLLATE=C
    
    local length="${#1}"
    for (( i = 0; i < length; i++ )); do
        local c="${1:i:1}"
        case $c in
            [a-zA-Z0-9.~_-]) printf "$c" ;;
            *) printf '%%%02X' "'$c" ;;
        esac
    done
    
    LC_COLLATE=$old_lc_collate
}

urldecode() {
    # urldecode <string>

    local url_encoded="${1//+/ }"
    printf '%b' "${url_encoded//%/\\x}"
}

showhelp(){
	echo "tweet-dl : download tweet and render as plain text"
	echo "OPTIONS:"
	echo "\t-u, --url\tUrl of the tweet"
	echo "\t-s, --search\tSearch by word/hashtag and render the 1st tweet"
	echo "\t-f, --filter\tFilter on search: default=populars, tweets=lasts, users=users, images=photos, videos=videos, news=news, broadcasts=broadcasts"
	echo "\t-h, --help\tThis help information"
	echo "EXAMPLES:"
	echo "tweet-dl.sh --url \"https://twitter.com/god/status/885938022\" "
	echo "tweet-dl.sh --search \"#bitcoin\" "
	echo "tweet-dl.sh --search \"#bitcoin\" --filter \"tweets\" "
}

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
	showhelp
	exit
    ;;
    *)
    	showhelp
	exit
    ;;
esac
shift # past argument or value
done

if [ $# == 0 ] || [ $# == 1 ]
then
	showhelp
	exit
fi


if [[ -n "$SEARCH" ]]; then

	SEARCH=$(urlencode $SEARCH)
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
TEXT=$(echo $PAGE | awk -F'<title>|</title>' '{print $2}'  | xargs | recode --force --silent html..ascii )
TIME=$(echo $PAGE | awk -F'class="tweet-timestamp js-permalink js-nav js-tooltip" title=| data-conversation-id=' '{print $3}' )
TIME=$(echo $TIME | sed "s/\"//g")

echo $URL
echo $TEXT
echo $TIME



