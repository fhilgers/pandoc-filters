#!/usr/bin/env bash

PREAMBLE="local files = {}
local globalRequire = require
local require = function(path)
  return files[path]() or globalRequire(path)
end"

POSTAMBLE="return require('filter')"

convert_file() {
	name="$(basename "${1%%.lua}")"

	echo "-- BEGIN '$name' ---------------------------------------"
	echo "files['$name'] = function(...)"
	sed <"$f" 's/^/    /'
	echo "end"
	echo "-- END   '$name' ---------------------------------------"
}

echo "$PREAMBLE" >./dist/native-functions.lua

for f in ./pkgs/native-functions/*.lua; do
	convert_file "$f" >>./dist/native-functions.lua
done

echo "$POSTAMBLE" >>./dist/native-functions.lua
