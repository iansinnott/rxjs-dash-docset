const { Observable } = require('rxjs');

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

const replace = (regex, replacement) => str => str.replace(regex, replacement);

module.exports = {
  fromReadableStream,
  split,
  trim,
  replace
};
