#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'
# What's this gibberish?? http://redsymbol.net/articles/unofficial-bash-strict-mode/

check_for_update() {
	echo "Checking for update..."
	(cd rxjs; git pull)

	local current_version=$(node -e 'process.stdout.write(require("./dist/docset.json").version)')
	local latest_version=$(node -e 'process.stdout.write(require("./rxjs/package.json").version)')

	# Do nothing if there is no update
	if [[ $current_version == $latest_version ]]; then
		echo "Nothing to update."
		exit 1
	fi

	echo "Update detected: ${current_version} -> ${latest_version}"

	# Make sure versions exists
	mkdir -p ./dist/versions

	# Copy over the current version
	echo "Moving current version to: ./dist/versions/${current_version}.tgz"
	mv ./dist/RxJS.tgz ./dist/versions/${current_version}.tgz

	# Remove all but the versions dir. Matches everything with an extension
	rm -rf ./dist/*.*

	# Clear out the docs in order to rebuild them
	rm -rf ./rxjs/tmp

	# Run it. At this point it's just the build script. Removing the tmp dir from
	# rxjs above should ensure that everything gets re-run
	echo "Rebuilding..."
	make clean build
}

check_for_update
