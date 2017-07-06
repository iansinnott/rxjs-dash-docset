publish() {
	local version=$(node -e 'process.stdout.write(require("./dist/docset.json").version)')

	# - Do git tagging to ensure a git tag is set BEFORE we publish
	# - Push all updates
	# - Do the actual publish. Still not sure how to do this since it involves
	#   another repo

	git add . && git commit -m "Update: v${version}"

	git tag "v${version}" -m "v${version}"

	echo "Publishing RxJS v${version}..."
}

make check_for_update && publish
