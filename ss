#!/bin/sh

# configure this
source ~/.ssrc

# temporary file
tmp="$(mktemp -u --suffix=.png)"

# get imgur upload function
DIR="$(cd "$(dirname "$0")" && pwd)"
source "$DIR/imgurbash.sh"

# grab rectangle (remove -r option if using the upstream scrot)
sleep .1
scrot -sr "$tmp"

if [ $? -eq 0 ]; then
	failed=0

	# check for imgur flag
	if [ $# -gt 0 ] && [ $1 = "--imgur" ]; then
		# upload screenshot to imgur
		link="$(upload2imgur "$imgur_api_key" "$tmp")"
		if [ $? -ne 0 ]; then
			failed=1
		fi
	else
		# upload screenshot to custom server
		link="$(curl -F "passwd=$password" -F "img=@$tmp" "$url")"
		if [ $? -ne 0 ]; then
			failed=1
		fi
	fi

	# notify (may output error message too)
	notify-send ss "$link"

	# failed?
	if [ $failed -eq 0 ]; then
		# copy to clipboard only if successful
		echo -n "$link" | xsel -b
	fi
else
	# screenshot fail
	notify-send ss "could not take screenshot"
fi

# remove temporary file if any
rm -f "$tmp"
