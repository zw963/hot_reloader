# frozen_string_literal: true

module HotReloader
  VERSION = [0, 8, 2]

  class << VERSION
    include Comparable

    def to_s
      join('.')
    end
  end
end
