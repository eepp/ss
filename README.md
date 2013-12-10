ss - easy screenshot sharing for X
==================================

This simple script does the following when executed:

  1. executes `scrot` to draw a rectangle on the screen and save a PNG image
  2. uploads this image to a custom server
  3. copies the image URL on the server to the clipboard
  4. notifies the user that everything is done

If a keyboard shortcut is used to call this script, I call this easy screenshot sharing for X.

dependencies
------------

You need all the following:

  * [eepp's version of `scrot`](https://github.com/eepp/scrot)
     if you want to support the `-r` option, which
     makes it possible to resize/move the drawn rectangle; otherwise, the upstream
     version is fine, just remove the `-r` option in the script
  * `curl` package
  * `libnotify` package (for `notify-send`)
  * `xsel` package (for copying to clipboard)

configuration
-------------

`ss` sources `~/.ssrc`. This file must define two variables:

  * `url`: the endpoint `curl` will access
  * `password`: your password for uploading images

Here's an example:

```
url="http://example.com/ss/up"
password="peanut-butter"
```

The endpoint must accept a POST request with the following variables:

  * `img`: PNG image data
  * `passwd`: plain text password

The response body must be the full URL of the stored image.

using with...
-------------

### Fluxbox

Add this to your `~/.fluxbox/keys`:

```
180 :exec /path/to/ss
```

Replace `180` by the keycode or key combination of your choice.
