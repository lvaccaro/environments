#!/bin/bash

# Array of kermit photos
declare -a photos=("http://68.media.tumblr.com/ba7a5fea838624e1189d11dbd212d6b7/tumblr_nh4w7lDK4r1tbzo3vo1_1280.jpg"
"http://68.media.tumblr.com/8aaa8c08576620cb9de7c3fe7e243ecf/tumblr_ncb585fcBt1tbzo3vo1_1280.jpg"
"http://68.media.tumblr.com/e34f41d11017a1199d773a65902aacf9/tumblr_nalwa2W5jF1tbzo3vo1_1280.jpg"
"http://68.media.tumblr.com/99af6ecaf55f25f26cc9df4af85bb0ce/tumblr_n6gor1liVO1tbzo3vo1_1280.jpg"
"http://68.media.tumblr.com/2aebb124c2c3001aa0311799489d3526/tumblr_n6g5g51uPg1tbzo3vo1_1280.jpg"
"http://68.media.tumblr.com/f9b168b3cedfb922421ac1311180d1b3/tumblr_n6dwecG4p71tbzo3vo1_1280.jpg"
"http://68.media.tumblr.com/a25fddc78fc9360f7a689175554e0517/tumblr_n6ctp7imdH1tbzo3vo1_1280.jpg"
"http://68.media.tumblr.com/d5995460c289a39535bb886cb8921d02/tumblr_n6aqrz4Fz21tbzo3vo1_1280.jpg"
"http://68.media.tumblr.com/aec290b27f06c2c0cb49cb3dde56c623/tumblr_n69abhj17X1tbzo3vo1_1280.jpg"
"http://68.media.tumblr.com/86ef53fed597d581dee338f8aec37168/tumblr_n66l2uxe9A1tbzo3vo1_1280.jpg"
"http://68.media.tumblr.com/d65936c2db5a55f07fd8b3781ce27321/tumblr_n64xrkCdPE1tbzo3vo1_1280.jpg"
"http://68.media.tumblr.com/7d6fa516bc65c89ca6159ea29ba6da69/tumblr_n60yfnEtXD1tbzo3vo1_1280.jpg"
"http://68.media.tumblr.com/5ccf2c33124a5cef3da6f255c8d1a6d3/tumblr_n5y5gbH7YE1tbzo3vo1_1280.jpg"
"http://68.media.tumblr.com/6e2d58652984b44867c4e4404b909add/tumblr_n5u7cksuku1tbzo3vo1_1280.jpg"
"http://68.media.tumblr.com/098f8d8b86f9b4d1a4709ed5a787a764/tumblr_n5rv7hmgM21tbzo3vo1_1280.jpg"
"http://68.media.tumblr.com/6385923c11fd8a6abffa502c620c990d/tumblr_n5qn68Gzg61tbzo3vo1_1280.jpg"
"http://68.media.tumblr.com/689e2e2e6de93b18e2bb5dc40c3cf4c4/tumblr_n5oipxYwiP1qav6pmo1_1280.jpg"
"http://68.media.tumblr.com/6d54b5b16254c749fd8a43f165dd7144/tumblr_n5o9nddkzV1tbzo3vo1_1280.jpg"
"http://68.media.tumblr.com/df6b4008212087e07d7b869a1df0213c/tumblr_n5mi6nKwfC1tbzo3vo1_1280.jpg"
"http://68.media.tumblr.com/b31cf78703169390b3fae66120ae96fd/tumblr_n5kmhkg5oq1tbzo3vo1_1280.jpg"
"http://68.media.tumblr.com/5a2a62834856be01551854a2d2376d42/tumblr_n5ewalu7HB1tbzo3vo1_1280.jpg"
"http://68.media.tumblr.com/12166a1701bca2a5362a17a13ec48b28/tumblr_n5ew9b9zsu1tbzo3vo1_1280.jpg"
"http://68.media.tumblr.com/c06d8209f6f8ede7944df27fea6bcb62/tumblr_n5ew7dVmdI1tbzo3vo1_1280.jpg"
"http://68.media.tumblr.com/dafedc4077e654faf7f878ac99314907/tumblr_n5ew68seJe1tbzo3vo1_1280.jpg"
"http://68.media.tumblr.com/1c50596aef99a67b2a44c7642fe052b4/tumblr_n5ew5d39kv1tbzo3vo1_1280.jpg"
"http://68.media.tumblr.com/4c727b23c71aa76850710119f44eb122/tumblr_n5ew4kNEzY1tbzo3vo1_1280.jpg"
"http://68.media.tumblr.com/a5cab3412b026bf86b90659fa850f9e4/tumblr_n5ew3kL5pI1tbzo3vo1_1280.jpg"
"http://68.media.tumblr.com/c1128c8971a719a9fdb25586399578a7/tumblr_n5evy272Sp1tbzo3vo1_1280.jpg"
"http://68.media.tumblr.com/b5a46d604a6c06683a3755b010659998/tumblr_n5evwsIutq1tbzo3vo1_1280.jpg"
"http://68.media.tumblr.com/f5c9bddf7baf20bef1c19e7f7a108ce6/tumblr_n5evuaLcrW1tbzo3vo1_1280.jpg"
)

# Select random the photo
index=$( jot -r 1  0 $((${#photos[@]} - 1)) )
selected_photo=${photos[index]}
#echo $selected_photo

# Download the photo on /tmp folder
curl $selected_photo > /tmp/kermit.jpg

# Run osascript to change desktop background
osascript <<EOD
tell application "Finder"
set desktop picture to POSIX file "/tmp/kermit.jpg"
end tell
EOD
