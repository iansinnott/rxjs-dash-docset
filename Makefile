.PHONY: clean prebuild list_matched_files

# Where logs will be stored.
outfile = build_log.txt

# Silly amount of aliasing? Maybe
all: build

build: rxjs.docset

clean:
	rm -rf ./rxjs.docset
	rm -rf ./tmp

# Grab the dashing binary. This way we don't need go installed
dashing.sh:
	curl -L https://github.com/technosophos/dashing/releases/download/0.3.0/dashing > ./dashing.sh
	chmod +x ./dashing.sh

# Clone down the rxjs repo
rxjs:
	git clone --depth=1 https://github.com/ReactiveX/rxjs.git rxjs

yarn.lock:
	yarn install

# Build the official docs from source
# TODO: Is there a cleaner way to execute a bunch of commands from a certain
# directory?
#
# NOTE: Make didn't recognize the file as already built until I touched it
rxjs/tmp/docs/index.html: rxjs yarn.lock
	(cd rxjs && yarn install && yarn run build_docs)
	touch rxjs/tmp/docs/index.html

# What was I doing here? I think this was related to dashing matching some empty
# selectors within these files, AND the filtering options of dashing being
# completely useless. The filtering options and advanced selectors seemt to be
# completely ignored
#
# -f keeps this from affecting exit status even if these files have already been
# removed
prebuild:
	rm -f rxjs/node_modules/esdoc/out/src/Publisher/Builder/template/class.html
	rm -f rxjs/node_modules/esdoc/out/src/Publisher/Builder/template/details.html

# Sort of semantically confusing that this is separate from the prebuild
# command... since it's part of what happens before build. Meh
post_process_html: rxjs/tmp/docs/index.html
	cp -R ./rxjs/tmp/docs ./tmp
	find ./tmp -iname '*.html' | node process-html.js
	cp ./dashing.* ./tmp
	cp ./icon* ./tmp

# Build the docset using dashing
rxjs.docset: prebuild post_process_html
	(cd ./tmp; ./dashing.sh build > $(outfile))
	mv ./tmp/$(outfile) ./
	mv ./tmp/rxjs.docset ./

# The sed replacement first removes everything up to 'rxjs' then it strips the
# hash at the end.
#
# NOTE: It's important to use double dollar sign '$$' in a makefile like this
# since make will interpret dollar signs in a special way
#
# Example:
# "Match: 'some thing' as type Guide at rxjs/tmp/docs/blah.../filename.html#hash"
# -> "rxjs/tmp/docs/blah.../filename.html#hash"
# -> "rxjs/tmp/docs/blah.../filename.html"
#
# This would be much simpler if we didn't check for the outfile...
list_matched_files:
	if [ -f $(outfile) ]; then \
		cat $(outfile) | ag 'is type .+ at' | sed -E -e 's/.+rxjs/rxjs/' -e 's/#.+$$//' | sort | uniq; \
	else \
		echo "Outfile: \"$(outfile)\" not found. Maybe you need to run \"make rxjs.docset\""; \
	fi
