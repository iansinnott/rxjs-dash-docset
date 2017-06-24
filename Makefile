all: rxjs.docset

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
	(cd rxjs; yarn; yarn build_docs)

# Build the docset using dashing
rxjs.docset: rxjs/tmp/docs/index.html
	./dashing.sh build
