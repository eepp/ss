#!/bin/sh

# configure this
source ~/.ssrc

# temporary file
tmp="$(mktemp -u --suffix=.png)"

# argument flag to upload to imgur.com
imgur_flag="--imgur"

# set variables to call imgur script
DIR="$(cd "$(dirname "$0")" && pwd )"
imgur_upload_path=$DIR"/imgurbash.sh"

# grab rectangle (remove -r option if using the upstream scrot)
scrot -sr "$tmp"

if [ $? -eq 0 ]; then
	# check for imgur flag
	if [ $# -gt 0 ] && [ $1 = $imgur_flag ];
	then
		# upload screenshot to Imgur.com
		link="$("$imgur_upload_path" "$tmp")"
	else
		# upload screenshot to custom server
		link="$(curl -F "passwd=$password" -F "img=@$tmp" "$url")"
	fi

	# copy to clipboard
	echo -n "$link" | xsel -ib

	# notify
	notify-send ss "$link"
else
	# fail
	notify-send ss "could not take screenshot"
fi

# remove temporary file if any
rm -f "$tmp"
