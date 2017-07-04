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

## Architecture

(If that's what you want to call it)

```
(1) generate original docs
 ↓
(2) transform
 ↓
(3) generate indexed docs
```

**Step 1:** should be easy since any project you would want to bring into Dash likely already has docs... Suffice to say there should be a command to generate docs. Run it and know where the output docs are located.

**Step 2:** This could be optional, but you will probably want to do it to make the docs look nice. This is the step where you can strip out extraneous UI such ans navigation menus. It's also the perfect time to modify markup to make it simpler for Dashing to parse.

**Step 3:** Generate the final docs. Without Dashing there would be some non trivial work to do here, but dashing does a pretty damn good job. As noted in "Issues" above it seems to be buggy and not support much customization **at all**. But, Step 2 completely obviates the need for Dashing to do any mapping or filtering so all that's left to do is find the selectors that correspond to [Dash entry types][].

[Dash entry types]: https://kapeli.com/docsets#supportedentrytypes

## Workflow

If the architecture is the "what" this is the "how". It's actually pretty simple to get what you need done using a combination of Node for step 2 and Dashing for step 3.

### Step 2 Workflow

With the original docs generated locally, open them up in the browser. The local docs, **not** the online ones. With the docs open in the browser open the inspector and start modifying them to look good in Dash.

* Remove anything nav related
* Remove any scripts you can rule out as necessary
* Improve the styling of things
  * Page should be flexible
  * Text should wrap unless `pre`, in which case it should overflow auto
  * Images should be flexible but with a max width
  * etc...

Playing around with this stuff in the browser is just to get a sense for what works. Once you have it, code it up in a node script using Cheerio to handle the DOM interaction. I prefer to create a script that works like `sed` on steroids: reading from stdin, modifying the stream and outputting to stdout. But the mechanics of the script are up to you, just make sure it works for you.

One reason a `sed`-like interface works nicely is that you can just drop a call to your node script into a bash pipeline (probably the end of the pipeline).

### Step 3 Workflow

Prep all the pages for Dashing. This definitely interrelates with step 2, but now we're focusing on the interaction between Dashing and the DOM. Dashing works by combining the functionality of identifying an entry type _and_ it's title with a single selector. This seemed like a limitation

* Update the DOM to make it easy for Dashing to grab Entry types (this step is what makes Dashing so useful)
  * Ex: If you have a section that is difficult (or impossible) to uniquely select add your own markup. If you need to select all container divs that have a certain child you can do that with DOM traversal which Cheerio makes pretty straightforward.
* Update page titles to remove extraneous info, like `' | RxJS 5 Documentation'`

Then finally just run it. I like `make` for wiring everything together.

Dashing is very limited in its configurability, including where it runs from. It seems to traverse the whole file tree starting at itself. So, you will want to drop Dashing directly in to the newly transformed docs along with its configuration and let it run from there. Simple enough once I found this out, I just figured it would have an option to specify a different root.

## TODO

* Versioning scheme?
  * What's the best way to auto-update the docs as new versions of Rx come out?
