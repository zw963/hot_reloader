require 'hot_reloader'

class HotReloaderTest < Minitest::Test
  def test_will_listen
    file = File.expand_path("./test_a", __dir__)
    HotReloader.will_listen(file)
  end

  def test_eager_load_all
    file = File.expand_path("./test_b", __dir__)
    HotReloader.eager_load(file)
  end
end
