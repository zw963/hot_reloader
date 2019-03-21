class HotReloader
  VERSION = [0, 3, 0]

  class << VERSION
    def to_s
      join('.')
    end
  end
end
