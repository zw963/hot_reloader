# frozen_string_literal: true

require 'zeitwerk'
require 'listen'

class HotReloader
  class << self
    # Listen on folders for file change, and reload changed rb file if necessary.
    # Should be used for development mode only.
    #
    # @param [*String, Array<String>] folders Folders which should be monitor, can be multi-args or array.
    #   or only one Zeitwerk::Loader object can be provided.
    # @param [#call] logger logger object, e.g. Logger.new($stdout).
    # @param [Array<String>, Array<Pathname>] ignore File names, Glob patterns or Pathname object which should be excluded for zeitwerk.
    # @param [Integer] wait_for_delay Set the delay (in seconds) before call loader.reload when changes exist.
    # @param [Array<Regexp>] listen_ignore The regexp pattern which don't want listen on.
    # @yield [] ruby code will be run after Zeitwerk loader get reloaded.
    # @return nil
    def will_listen(*folders, logger: Logger.new(IO::NULL), ignore: [], wait_for_delay: nil, listen_ignore: [])
      folders = folders.flatten

      if folders.first.is_a? Zeitwerk::Loader
        loader, *listened_folders = folders
        folders = loader.__roots.keys
        # `folders' will add to zeitwerk root directories and listened.
        # `reloadable_folder' listened only, it can be reload dynamically.
        # but not constant lookup use name convention.
      else
        loader = Zeitwerk::Loader.new

        raise 'you must set the root directories from which you want to load watched files.' if folders&.empty?
        raise 'ignore: only accept an array of glob patterns string or Pathname objects.' unless ignore.is_a? Array

        folders.each {|folder| loader.push_dir(folder) }
        listened_folders = []
      end

      loader.enable_reloading if loader.respond_to? :enable_reloading
      loader.logger = logger
      loader.ignore(ignore) unless ignore.empty?
      loader.setup

      Listen.logger = logger

      listen_options = {ignore: [/\A\.?#/]}
      listen_options.merge!({wait_for_delay: wait_for_delay}) if wait_for_delay
      listen_options[:ignore].concat listen_ignore if listen_ignore

      Listen.to(*(folders + listened_folders), listen_options) do
        loader.reload
        yield if block_given?
      end.start
    end

    # Enable autoload ruby file based on default Zeitwerk rule.
    # More rule see https://github.com/fxn/zeitwerk
    #
    # @param [*String, Array<String>] folders folders which should be autoload, can be multi-args or array.
    #   or only one Zeitwerk::Loader object can be provided.
    # @param [#call] logger logger object, e.g. Logger.new($stdout)
    # @param [Array<String>, Array<Pathname>] ignore File names, Glob patterns or Pathname object which should be excluded for zeitwerk.
    # @return nil
    def eager_load(*folders, logger: Logger.new(IO::NULL), ignore: [])
      folders = folders.flatten

      if folders.first.is_a? Zeitwerk::Loader
        loader = folders.first
        folders = loader.__roots.keys
      else
        loader = Zeitwerk::Loader.new

        raise 'you must set the root directories from which you want to load watched files.' if folders&.empty?
        raise 'ignore: only accept an array of glob patterns string or Pathname objects.' unless ignore.is_a? Array

        folders.each {|folder| loader.push_dir(folder) }
      end

      loader.logger = logger
      loader.ignore(ignore) unless ignore.empty?

      loader.setup
      loader.eager_load
    end
  end
end
