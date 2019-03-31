class HotReloader
  VERSION = [0, 3, 1]

  class << VERSION
    def to_s
      join('.')
    end
  end
end
