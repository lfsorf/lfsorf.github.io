#!/bin/env bash

# assuimg I'll run this script at ./blog/raw
# list all files whose file extenstion is .md
# and strip their extensions.
input=$(find . -name '*.md' | cut -f2 -d. -) 

for file in $input
do
    mdhash="<!--$(md5sum .$file.md)-->"
    if [[ -f "..$file.html" ]] && ! [[ "$1" =~ -{1,2}f(orce)? ]]
    then
        # skip if a file remains unchanged
        compiledhash="$(tail ..$file.html --line 1)"
        if [[ $mdhash == $compiledhash ]]
        then
            echo "No changes found on .$file.md"
            continue
        fi
    fi
    echo "Compiling .$file.md..."
    pandoc ".$file.md" \
        --from commonmark \
        --standalone \
        --css /sakura.css \
        --output "..$file.html"
    echo "$mdhash" >> ..$file.html
done
