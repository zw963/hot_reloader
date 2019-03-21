require 'singleton'
require 'zeitwerk'
require 'listen'

class HotReloader
  include Singleton

  def initialize
    @loader = Zeitwerk::Loader.new
  end

  class << self
    def will_listen(*folders, logger: method(:puts), ignore: [])
      folders = folders.flatten
      setup_loader(folders, logger: logger, ignore: ignore)
      Listen.to(*folders) { loader.reload }.start
    end

    def eager_load(*folders, logger: method(:puts))
      folders = folders.flatten
      setup_loader(folders, logger: logger, ignore: [])
      loader.eager_load
    end

    private

    def loader
      instance.instance_variable_get(:@loader)
    end

    def setup_loader(folders, logger:, ignore:)
      raise 'ignore: only accept an array of glob patterns string or Pathname objects.' unless ignore.is_a? Array
      raise 'you must set the root folders from which you want to load watched files.' if folders&.empty?

      folders.each {|folder| loader.push_dir(folder) }
      loader.logger = logger
      loader.ignore(ignore) unless ignore.empty?
      loader.setup
    end
  end
end
