## interblah.net
It's my blog-type thing, and it runs using [Vanilla][], which is a blog-type thing engine.

You can view this site running at http://interblah.net

Feel free to poke around - pull requests for typos and broken bits are always appreciated ;-)

## Development Setup

### Dependencies

The site uses Ruby (via Bundler) and Node.js (for CSS compilation):

```bash
# Install Ruby dependencies
bundle install

# Install Node.js dependencies for CSS compilation
npm install
```

### CSS Compilation

The site uses [Tachyons SCSS](https://github.com/tachyons-css/tachyons-sass) with [Dart Sass](https://sass-lang.com/dart-sass/):

```bash
# Compile full CSS (86KB compressed)
bundle exec rake css

# Compile and purge unused CSS (6KB compressed)
bundle exec rake purgecss
```

The CSS workflow:
- **Source**: `public/stylesheets/scss/interblah.scss`
- **Full output**: `public/stylesheets/interblah.css` (includes all Tachyons utilities)
- **Purged output**: `public/stylesheets/interblah.min.css` (only used classes)

PurgeCSS scans the homepage and test page to determine which classes are actually used, keeping all necessary styles while removing unused Tachyons utilities.

[Vanilla]: https://github.com/lazyatom/vanilla-rb
