#!/bin/sh

# configure this
source ~/.ssrc

# temporary file
tmp="$(mktemp -u --suffix=.png)"

# grab rectangle (remove -r option if using the upstream scrot)
scrot -sr "$tmp"

if [ $? -eq 0 ]; then
	# upload screenshot
	link="$(curl -F "passwd=$password" -F "img=@$tmp" "$url")"

	# copy to clipboard
	echo "$link" | xsel -b

	# notify
	notify-send ss "$link"
else
	# fail
	notify-send ss "could not take screenshot"
fi

# remove temporary file if any
rm -f "$tmp"
