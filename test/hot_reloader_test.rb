require 'hot_reloader'

describe "HotReloader" do
  it "should support paths as args" do
    HotReloader.will_listen("#{__dir__}/test_a/a")
    HotReloader.eager_load("#{__dir__}/test_a/b")
    assert_raises(Zeitwerk::NameError) do
      HotReloader.eager_load("#{__dir__}/test_a/c")
    end
  end

  it "should support path array as args" do
    HotReloader.will_listen(["#{__dir__}/test_b/a"])
    HotReloader.eager_load(["#{__dir__}/test_b/b"])
  end

  it "should support autoload and reload and logger when use will_listen" do
    loader = Zeitwerk::Loader.new
    loader.push_dir("#{__dir__}/test_d/a")
    assert_output(nil, /autoload set for TestDA/) do
      HotReloader.will_listen(loader, "#{__dir__}/test_d/b", logger: Logger.new($stderr))
    end
  end

  it "should support eagerloading" do
    loader = Zeitwerk::Loader.new
    loader.push_dir("#{__dir__}/test_e/a")
    assert_output(nil, /autoload set for TestEA/) do
      HotReloader.eager_load(loader, logger: Logger.new($stderr))
    end
  end
end
