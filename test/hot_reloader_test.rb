require 'hot_reloader'

class HotReloaderTest < Minitest::Test
  def test_will_listen
    HotReloader.will_listen(File.expand_path("../", __dir__))
  end

  def test_eager_load_all
    HotReloader.eager_load_all
  end
end
