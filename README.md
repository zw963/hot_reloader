# HotReloader [![Build Status](https://travis-ci.org/zw963/hot_reloader.svg?branch=master)](https://travis-ci.org/zw963/hot_reloader) [![Gem Version](https://badge.fury.io/rb/hot_reloader.svg)](http://badge.fury.io/rb/hot_reloader)

A dead simple ruby code hot reloader wrapper around [zeitwerk](https://github.com/fxn/zeitwerk) and [listen](https://github.com/guard/listen).

See README for those gems for usage.

## Getting Started

Install via Rubygems

    $ gem install hot_reloader

OR ...

Add to your Gemfile

    gem 'hot_reloader'

## Usage

Following is a example for use hot_reloader with [Roda](https://github.com/jeremyevans/roda):

```rb
# config.ru

require 'roda'
require 'hot_reloader'

if ENV['RACK_ENV'] == 'production'
  HotReloader.will_listen(__dir__)
  run ->(env) {
    App.call(env)
  }
else
  run App
end
```

Then create app.rb in ROOT directory.

```rb
# app.rb

class App < Roda
  articles = []

  route do |r|
    r.post "articles" do
    articles << r.params["content"]
    "Count: #{articles.count}"
    end
  end
end
```

Directory structure is like this:

```
├── app.rb
├── config.ru
├── Gemfile
└── Gemfile.lock
```

Change code in app.rb, **all constant get removed from memory, and app.rb evaluated again**!

## Support

  * MRI 2.4.4+
  * JRuby

## Dependency

zeitwerk https://github.com/fxn/zeitwerk
listen https://github.com/guard/listen

## Contributing

  * [Bug reports](https://github.com/zw963/hot_reloader/issues)
  * [Source](https://github.com/zw963/hot_reloader)
  * Patches:
    * Fork on Github.
    * Run `gem install --dev hot_reloader` or `bundle install`.
    * Create your feature branch: `git checkout -b my-new-feature`.
    * Commit your changes: `git commit -am 'Add some feature'`.
    * Push to the branch: `git push origin my-new-feature`.
    * Send a pull request :D.

## license

Released under the MIT license, See [LICENSE](https://github.com/zw963/hot_reloader/blob/master/LICENSE) for details.
