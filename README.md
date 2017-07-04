# RxJS 5 Dash Docs

![RxJS in Dash](https://dropsinn.s3.amazonaws.com/Screen%20Shot%202017-07-04%20at%201.36.51%20AM.png)

![RxJS mergeMap in Dash](https://dropsinn.s3.amazonaws.com/Screen%20Shot%202017-07-04%20at%201.38.50%20AM.png)

---
<!-- Everything below this point will not be included in the dist sent to Dash -->

## Install Locally

The easiest way to install this is definitely through Dash, but when I wrote
this readme the package wasn't yet live in Dash. So to install locally, download
RxJS.tgz and extract it. Then in Dash:

Preferences > Docsets > + (the plus sign in the lower left) > Add Local Docset

Then chose the folder where you extracted RxJS.tgz. You're all set.

## Build

### Install dependencies

You will need:

* yarn
* imagemagick
* graphicsmagick
* ghostscript

Easiest option is probably brew:

**NOTE:** I'm ignoring yarn dependencies since you probably have Node already installed your your system.

```
brew install yarn --ignore-dependencies
brew install imagemagick graphicsmagick ghostscript
```

Now, to build:

```
make
```

To *re*build, add in `clean`:

```
make clean build
```

## Issues

Dashing seems to completely ignore all its [mapping/filtering options](https://github.com/technosophos/dashing#other-mappersfilters-on-selectors) entirely. I've left them in here in case they start working again later... but they do NOT work yet.

## TODO

* Versioning scheme?
  * What's the best way to auto-update the docs as new versions of Rx come out?
