#!/bin/sh

# imgur script by Bart Nagel <bart@tremby.net>
# version 4
# I release this into the public domain. Do with it what you will.
#
# refactoring into a function by Philippe Proulx <eepp.ca>

upload2imgur() {
	api_key="$1"
	filename="$2"

	# the "Expect: " header is to get around a problem when using this through
	# the Squid proxy. Not sure if it's a Squid bug or what.
	response=$(curl -F "key=$api_key" -H "Expect: " -F "image=@$filename" \
		http://imgur.com/api/upload.xml 2>/dev/null)

	if [ $? -ne 0 ]; then
		echo 'imgur upload failed'
		return 1
	elif [ $(echo $response | grep -c '<error_msg>') -gt 0 ]; then
		echo -n 'imgur error: '
		echo -n "$response" | sed -r 's/.*<error_msg>(.*)<\/error_msg>.*/\1/'
		return 1
	fi

	# parse the response and output our stuff
	echo -n "$(echo $response | sed -r 's/.*<original_image>(.*)<\/original_image>.*/\1/')"
}
