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

### Add loader initialize code into `config/environment.rb`

For simple use case, you just need pass paths to `HotReloader.eager_load` or `HotReloader.will_listen`.

```rb
# config/environment.rb

require 'bundler'
Bundler.require(:default, ENV.fetch('RACK_ENV', "development"))
require_relative 'application'

paths = ["#{__dir__}/../app", "#{__dir__}/../app/models"]

if ENV['RACK_ENV'] == 'development'
  HotReloader.will_listen(*paths)
else
  HotReloader.eager_load(*paths)
end
```

For more advanced case(e.g. you need setup zeitwerk loader instance yourself), you
can pass this instance to HotReloader methods too.

```rb
# config/environment.rb

require 'bundler'
Bundler.require(:default, ENV.fetch('RACK_ENV', "development"))
require_relative 'application'

loader = Zeitwerk::Loader.new
loader.push_dir("#{__dir__}/../app")
loader.push_dir("#{__dir__}/../app/models")

if ENV['RACK_ENV'] == 'development'
  HotReloader.will_listen(loader)
else
  HotReloader.eager_load(loader)
end
```

When you change root directories files(app/*.rb or app/models/*.rb for above case), 
all monitored files will be reload.

it is possible to trigger reload from any `.rb` files, even this file not follow constant 
lookup name convention, and this file folder not add to root directories use `push_dir` method.

Following is a example.

```rb
# app/app.rb

class App < Roda
  plugin :hash_routes
  
  Dir["routes/**/*.rb"].each do |route_file|
    load route_file
  end
end
```

```rb
# routes/blog.rb

class App
  hash_routes.on "blog" do |r|
    "blog"
  end
end
```

`routes/blog.rb` is not follow constant lookup name convention, so, `routes/` folder can't be
add to root directories use push_dir method, but you can always trigger with `loader.reload`
if `routes/blog.rb` was changed, then when `app/app.rb` reloaded, it will load the
newest code in `routes/blog.rb` from the Dir each loop.

For achieve this, you only need pass listened folders to will_listen method as secondary arg.

```
loader = Zeitwerk::Loader.new
loader.push_dir("#{__dir__}/../app")

listened_folders = ["#{__dir__}/../routes"]

if ENV['RACK_ENV'] == 'development'
  HotReloader.will_listen(loader, listened_folders)
else
  HotReloader.eager_load(loader)
end
```

### Add other app files

`config.ru` which used to start rack based web server with `command rackup -o 0.0.0.0 -p 9393`

```rb
# config.ru

require_relative './config/environment'

if ENV['RACK_ENV'] == 'development'
  run ->(env) { App.call(env) }
else
  run App.freeze.app
end
```

Write whatever application needed initialize code into config/application.rb

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

After change code in app.rb, **all constant get removed from memory, and app.rb evaluated again**!

For a more rich WIP sample project, please check my another project [marketbet_crawler](https://github.com/zw963/marketbet_crawler).

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
