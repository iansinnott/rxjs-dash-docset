#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'
# What's this gibberish?? http://redsymbol.net/articles/unofficial-bash-strict-mode/

VERSION=$(node -e 'process.stdout.write(require("./rxjs/package.json").version)')

# Hm, initially I had the command below but that always packaged in such a way
# that the archive would extract to a dir with the name `tmp`. So it would end
# up being `tmp/RxJS.tgz`. That broke Dash's CI
echo "Packaging RxJS.tgz..."
(cd ./tmp; tar --exclude='.DS_Store' -cvzf RxJS.tgz RxJS.docset)
mv ./tmp/RxJS.tgz ./dist

echo "Updating docset.json with current version..."
cat docset.template.json | sed "s/\$VERSION_SUPPLIED_BY_SCRIPT_DO_NOT_MODIFY/$VERSION/" > ./dist/docset.json

#
echo "Trimming the readme and copying it over..."
cat ./README.md | node ./trim-readme.js > ./dist/README.md

# Copy images
echo "Copying images..."
cp ./icon{,@2x}.png ./dist

echo "Done."
