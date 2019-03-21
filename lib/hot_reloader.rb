require 'zeitwerk'
require 'listen'

module HotReloader
  module_function

  def will_listen(*directories, logger: method(:puts))
    loader = Zeitwerk::Loader.new
    loader.logger = logger
    directories.each {|directory| loader.push_dir(directory) }
    loader.setup
    Listen.to(*directories) { loader.reload }.start
  end

  def eager_load_all
    Zeitwerk::Loader.eager_load_all
  end
end
