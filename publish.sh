publish() {
	local version=$(node -e 'process.stdout.write(require("./dist/docset.json").version)')

	git add . && git commit -m "Update: v${version}"

	git tag "v${version}" -m "v${version}"

	git push && git push --tags

	echo "Publishing RxJS v${version}..."

	# - Still not sure how to automate the pull request since it involves
	#   another repo. However, the script below will work. It just has to be run
	#   from the other repo. Wherever that is on the fs

	cat <<EOT

TODO: Crate a publish script... because there isn't one yet. In order to
publish what just went live cd into wherever you have Dash-User-Contributions
cloned and then...

git checkout master && git pull && git checkout -b rxjs-${version}
rm -rf docsets/RxJS/*.*
git checkout -- docsets/RxJS/RxJS.tgz.txt
cp -R ${PWD}/dist/*.* docsets/RxJS/
git add . && git commit -m "RxJS v${version}"
git push -u $(git config --global user.username) rxjs-${version}
git pull-request -m "RxJS v${version}"

EOT
}

make check_for_update && publish
