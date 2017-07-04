# RxJS 5 Dash Docs

![RxJS in Dash](https://dropsinn.s3.amazonaws.com/Screen%20Shot%202017-07-03%20at%2010.18.05%20PM.png)

![RxJS mergeMap in Dash](https://dropsinn.s3.amazonaws.com/Screen%20Shot%202017-07-03%20at%2010.44.07%20PM.png)

## Build

### Install dependencies

You will need:

* yarn
* imagemagick
* graphicsmagick
* ghostscript

Easiest option is probably brew:

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
