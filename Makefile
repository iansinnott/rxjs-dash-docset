.PHONY: clean prebuild list_matched_files

# Where logs will be stored.
outfile = build_log.txt

all: rxjs.docset

clean:
	rm -rf ./rxjs.docset

# Grab the dashing binary. This way we don't need go installed
dashing.sh:
	curl -L https://github.com/technosophos/dashing/releases/download/0.3.0/dashing > ./dashing.sh
	chmod +x ./dashing.sh

# Clone down the rxjs repo
rxjs:
	git clone --depth=1 https://github.com/ReactiveX/rxjs.git rxjs

# Build the official docs from source
# TODO: Is there a cleaner way to execute a bunch of commands from a certain
# directory?
rxjs/tmp/docs/index.html: rxjs
	(cd rxjs && yarn && yarn build_docs)

# What was I doing here?
prebuild:
	rm rxjs/node_modules/esdoc/out/src/Publisher/Builder/template/class.html
	rm rxjs/node_modules/esdoc/out/src/Publisher/Builder/template/details.html

# Build the docset using dashing
rxjs.docset: rxjs/tmp/docs/index.html prebuild
	./dashing.sh build > $(outfile)
	echo "\nDone.\n"

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
