class HotReloader
  VERSION = [0, 2, 0]

  class << VERSION
    def to_s
      join('.')
    end
  end
end
