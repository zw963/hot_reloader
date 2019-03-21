require 'hot_reloader'

class HotReloaderTest < Minitest::Test
  def test_ok
    HotReloader.will_listen(File.expand_path("../", __dir__))
  end
end
