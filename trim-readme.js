const { fromReadableStream, trim, replace } = require('./utils.js');

/**
 * I use this file just for trimming the dev stuff off the readme. I would have
 * liked to use something like sed for this, but I guess my bash-fu is not yet
 * there. There was know readily available answer to how to do a multiline
 * replacement with sed.
 */

const replacement = `
**Author:** Ian Sinnott [@ian_sinn](https://twitter.com/ian_sinn) [github.com/iansinnott](https://github.com/iansinnott)

For...

* Instructions on how to generate
* Screenshots
* More info

Check out the README at [iansinnott/rxjs-dash-docset](https://github.com/iansinnott/rxjs-dash-docset)
`.trim();

fromReadableStream(process.stdin)
  .map(trim)
  .map(replace(/---[\s\S]+/gm, replacement))
  .subscribe(
    result => process.stdout.write(result),
    err => {
      process.exitCode = 1;
      console.log('Error trimming stdin', err);
    }
  );
