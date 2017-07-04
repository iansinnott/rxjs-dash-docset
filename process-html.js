const fs = require('fs');
const cheerio = require('cheerio');
const { Observable } = require('rxjs');
const { fromReadableStream, split, trim } = require('./utils.js');

const readFile = Observable.bindNodeCallback(fs.readFile);
const writeFile = Observable.bindNodeCallback(fs.writeFile);

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
