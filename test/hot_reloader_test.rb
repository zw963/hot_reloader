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

  def test_will_listen_zeitwerk_loader
    loader = Zeitwerk::Loader.new
    loader.push_dir("#{__dir__}/test_c")
    HotReloader.will_listen(loader)
  end

  def test_will_eager_load_zeitwerk_loader
    loader = Zeitwerk::Loader.new
    loader.push_dir("#{__dir__}/test_d")
    HotReloader.eager_load(loader)
  end
end
