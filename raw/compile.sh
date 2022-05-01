#!/bin/env bash

# assuimg I'll run this script at ./blog/raw
# list all files whose file extenstion is .md
# and strip their extensions.
input=$(find . -name '*.md' | cut -f2 -d. -) 

for file in $input
do
	mdsum="<!--$(md5sum .$file.md)-->"
	if test -f "..$file.html"
	then
		# skip if a file remains unchanged
		htmlsum="$(tail ..$file.html --line 1)"
		if [[ $mdsum == $htmlsum ]]
		then

			echo "No changes found on .$file.md"
			continue
		fi
	fi
	echo "Compiling .$file.md..."
	pandoc ".$file.md" \
		--standalone \
		--css /sakura.css \
		--output "..$file.html"
	echo "$mdsum" >> ..$file.html
done
