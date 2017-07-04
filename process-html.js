const fs = require('fs');
const { Observable, Subject } = require('rxjs');
const cheerio = require('cheerio');

const readFile = Observable.bindNodeCallback(fs.readFile);
const writeFile = Observable.bindNodeCallback(fs.writeFile);

const fromReadableStream = (stream) => Observable.create(obs => {
  const next = chunk => obs.next(chunk);
  const error = err => obs.error(err);
  const complete = () => obs.complete();

  // Set UTF-8 so we don't get Buffer instances read through
  stream.setEncoding('utf8');

  // Setup
  stream.on('data', next);
  stream.on('error', error);
  stream.on('end', complete);

  // Cleanup
  return () => {
    stream.removeListener('data', next);
    stream.removeListener('error', error);
    stream.removeListener('end', complete);
  };
});

const split = by => str => str.split(by);
const trim = str => str.trim();

// This file is essentially an advanced, html-aware sed command
// ============================================================

// read file list from stdin. Should be a single newline delimited string
// split the file list into an observable of individual file paths
// process the html (using cheerio?), doing all ops necessary to make it look as desired
// convert html back to string and write it again to the same filepath (overwrite)

const processHTML = (html) => {
  const $ = cheerio.load(html);

  const customStyles = `
.dash-contents img {
  max-width: 640px;
}
pre.prettyprint > code {
  overflow: auto;
}
  `.trim();

  const bannedScripts = new Set([
    'script/search_index.js',
    'script/search.js',
  ]);

  // Add custom styles
  $('head').append(`<style>${customStyles}</style>`);

  // Remove nav and header. The theme script fails without the header actually
  // being in the dom, and unfortunately the theme script is necessary to render
  // the page, so we don't remove the header.
  $('header').attr('style', 'display: none;');
  $('.navigation').remove();

  // Remove .content class and add some padding (the actual markdown content is
  // styled without this class, so it's fine)
  $('body > .content')
    .attr('style', 'padding: 20px;')
    .attr('class', 'dash-contents');

  // Mark up source code files so that dashing can actually latch on to them
  $('.dash-contents > .raw-source-code')
    .parent() // I.e. we actually want .dash-contents with a child of .raw-source-code.
    .addClass('dash-source-code');

  // Strip out the redundant text from document titles
  const $title = $('head > title');
  $title.text($title.text().replace(' | RxJS API Document', ''))

  // Remove scripts that either broke or didn't seem necessary to displaying
  // the docs
  $('script')
    .filter((_, el) => bannedScripts.has($(el).attr('src')))
    .remove();

  return $.html();
};

const main = () => {
  fromReadableStream(process.stdin)
    .map(trim)
    .mergeMap(split('\n')) // Note the mergeMap. This flattens array -> observable
    .mergeMap((path) => {
      return readFile(path, { encoding: 'utf8' })
        .map(processHTML)
        .mergeMap(processed => writeFile(path, processed))
        .mapTo(path); // Returning the path b/c write file doesn't actually return anything on success
    })
    .subscribe(
      path => console.log(`Post Processed: ${path}`),
      err => {
        console.log('Post Processing ERROR:', err);
        process.exitCode = 1;
      },
      () => console.log('Post Processing Complete')
    );
};

// Run it!
main();
