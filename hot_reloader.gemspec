require File.expand_path('../lib/hot_reloader/version', __FILE__)

Gem::Specification.new do |s|
  s.name                        = 'hot_reloader'
  s.version                     = HotReloader::VERSION
  s.date                        = Time.now.strftime('%F')
  s.required_ruby_version       = '>= 2.4.4'
  s.authors                     = ['Billy.Zheng(zw963)']
  s.email                       = ['vil963@gmail.com']
  s.summary                     = 'Just a dead simple wrapper around zeitwerk and listen.'
  s.description                 = ''
  s.homepage                    = 'http://github.com/zw963/hot_reloader'
  s.license                     = 'MIT'
  s.require_paths               = ['lib']
  s.files                       = `git ls-files bin lib *.md LICENSE`.split("\n")
  s.files                      -= Dir['images/*.png']
  s.executables                 = `git ls-files -- bin/*`.split("\n").map {|f| File.basename(f) }

  s.add_runtime_dependency 'zeitwerk', '~>1.4'
  s.add_runtime_dependency 'listen', '~>3.0'
end
