#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'
# What's this gibberish?? http://redsymbol.net/articles/unofficial-bash-strict-mode/

VERSION=$(node -e 'process.stdout.write(require("./rxjs/package.json").version)')

echo "Packaging RxJS.tgz..."
tar --exclude='.DS_Store' -cvzf ./dist/RxJS.tgz ./tmp/RxJS.docset

echo "Updating docset.json with current version..."
cat docset.template.json | sed "s/\$VERSION_SUPPLIED_BY_SCRIPT_DO_NOT_MODIFY/$VERSION/" > ./dist/docset.json

#
echo "Trimming the readme and copying it over..."
cat ./README.md | node ./trim-readme.js > ./dist/README.md

# Copy images
echo "Copying images..."
cp ./icon* ./dist

echo "Done."
