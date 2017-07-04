# RxJS 5 Dash Docs

## Build

### Install dependencies

You will need:

* yarn
* imagemagick
* graphicsmagick
* ghostscript

Easiest option is probably brew:

```
brew install yarn
brew install imagemagick graphicsmagick ghostscript
```

Now, to build:

```
make
```

## Issues

Dashing seems to completely ignore all its [mapping/filtering options](https://github.com/technosophos/dashing#other-mappersfilters-on-selectors) entirely. I've left them in here in case they start working again later... but they do NOT work yet.

## TODO

* Dashing needs to be configured to generate accurate docs
* Clean ?
* I may need a custom script to remove/hide parts of the page that make no sense in the context of Dash
  * Remove sidebar
  * Fix pre block text wrapping so that everything fits
  * Dark theme?
* Versioning scheme?
  * What's the best way to auto-update the docs as new versions of Rx come out?
