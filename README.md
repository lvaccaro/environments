# Environments
My personal scripts & global environment

### tweet-dl.sh
download tweet and render as plain text.
Usage: 
* tweet-dl.sh --url "https://twitter.com/god/status/885938022"
* tweet-dl.sh --search "#bitcoin" --filter "tweets" --language en

### cowtweet.sh
Redirect tweet-dl.sh output to cowsay with some formatting. 

A prerequisite is to have tweet-dl.sh in the same path.
* sh cowtweet.sh 

### kermit-desktop-osx.sh
Change the desktop background of your osx with an "Kermit The Frog" friendly wallpaper.
* sh kermit-desktop-osx.sh
* curl https://raw.githubusercontent.com/lvaccaro/environments/master/kermit-dekstop-osx.sh | sh
* curl -L goo.gl/3M4hJ2 | sh
