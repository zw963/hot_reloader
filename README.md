# HotReloader [![Build Status](https://travis-ci.com/zw963/hot_reloader.svg?branch=master)](https://travis-ci.com/zw963/hot_reloader) [![Gem Version](https://badge.fury.io/rb/hot_reloader.svg)](http://badge.fury.io/rb/hot_reloader)

A dead simple ruby code hot reloader wrap around [zeitwerk](https://github.com/fxn/zeitwerk) and [listen](https://github.com/guard/listen).

See README for those gems for usage.

## Getting Started

Install via Rubygems

    $ gem install hot_reloader

OR ...

Add to your Gemfile

    gem 'hot_reloader'

## Usage

Following is a example for use hot_reloader with [Roda](https://github.com/jeremyevans/roda):

`config.ru` which used to start rack based web server with `command rackup -o 0.0.0.0 -p 9393`

```rb
# config.ru

require_relative './config/environment'

if ENV['RACK_ENV'] == 'production'
  run App.freeze.app
else
  run ->(env) { App.call(env) }
end
```

Add loader initialize code into `config/environment.rb`


```rb
# config/environment.rb

require 'bundler'
Bundler.require(:default, ENV.fetch('RACK_ENV', "development"))
require_relative 'application'

loader = Zeitwerk::Loader.new
loader.push_dir("#{__dir__}/../app")
loader.push_dir("#{__dir__}/../app/models")
loader.inflector.inflect "ar" => "AR"

if ENV['RACK_ENV'] == 'production'
  HotReloader.eager_load(loader)
else
  HotReloader.will_listen(loader)
end
```

Or your can pass paths into hot_reloader directly (if you don't need setup Zeitwerk youself)


```rb
# config/environment.rb

require 'bundler'
Bundler.require(:default, ENV.fetch('RACK_ENV', "development"))
require_relative 'application'

paths = ["#{__dir__}/../app", "#{__dir__}/../app/models"]

if ENV['RACK_ENV'] == 'production'
  HotReloader.eager_load(*paths)
else
  HotReloader.will_listen(*paths)
end
```

Write whatever application initialize code which need add into application.rb

```rb
# config/application.rb

DB = Sequel.connect(ENV.fetch("#{ENV.fetch('RACK_ENV', "development").upcase}_DATABASE_URL"), timeout: 10000)
Sequel::Model.plugin :timestamps
Sequel.extension :symbol_aref
```

Add roda code into app/app.rb

```rb
# app/app.rb

class App < Roda
  articles = ['programming ruby', 'programming rust']
  route do |r|
    r.post "articles" do
      articles << r.params["content"]
      "Count: #{articles.count}"
    end
	
	r.get "articles" do
      articles.join(', ')
    end
  end
end
```

Directory structure is like this:

```
├── app/app.rb
├── config/environment.rb
├── config/application.rb
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
