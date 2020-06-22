# frozen_string_literal: true

require 'singleton'
require 'zeitwerk'
require 'listen'

class HotReloader
  include Singleton

  # @private
  def initialize
    @loader = Zeitwerk::Loader.new
  end

  class << self
    # Listen on folders for file change, and reload changed rb file if necessary.
    # Should be used for development mode only.
    #
    # @param [*String, Array<String>] folders Folders which should be monitor, can be multi-args or array.
    # @param [#call] logger logger or any object should response call.
    # @param [Array<String>] ignore Glob patterns or Pathname object which should be excluded.
    # @return nil
    def will_listen(*folders, logger: method(:puts), ignore: [])
      folders = folders.flatten

      raise 'you must set the root folders from which you want to load watched files.' if folders&.empty?
      raise 'ignore: only accept an array of glob patterns string or Pathname objects.' unless ignore.is_a? Array

      folders.each {|folder| loader.push_dir(folder) }
      loader.enable_reloading if loader.respond_to? :enable_reloading
      loader.logger = logger

      loader.ignore(ignore) unless ignore.empty?

      loader.setup
      Listen.to(*folders, wait_for_delay: 1) { loader.reload }.start
    end

    # Enable autoload ruby file based on default Zeitwerk rule.
    # More rule see https://github.com/fxn/zeitwerk
    #
    # @param [*String, Array<String>] folders folders which should be autoload, can be multi-args or array.
    # @param [#call] logger logger or any object should response call.
    # @return nil
    def eager_load(*folders, logger: method(:puts))
      folders = folders.flatten

      raise 'you must set the root folders from which you want to load watched files.' if folders&.empty?

      folders.each {|folder| loader.push_dir(folder) }
      loader.logger = logger

      loader.setup
      loader.eager_load
    end

    private

    def loader
      instance.instance_variable_get(:@loader)
    end
  end
end
