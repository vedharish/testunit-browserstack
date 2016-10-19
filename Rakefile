require 'rake'
require 'yaml'
require 'parallel'
require 'test/unit'
require 'test/unit/ui/console/testrunner'
require 'browserstack/local'
require './specs/single_test.rb'
require './specs/local_test.rb'

def populate_tests(config, test_list, invoke_method=SingleTest)
  config["browser_caps"].each do |browser_caps|
    caps = config["common_caps"].clone
    caps.merge!(browser_caps)
    test_list << invoke_method.new('google_test', {
      username: ENV['BROWSERSTACK_USERNAME'] || config['user'],
      access_key: ENV['BROWSERSTACK_ACCESS_KEY'] || config['key'],
      caps: caps
    })
  end
  test_list
end

task :single do |t, args|
  puts "Running Single Tests"
  config = YAML.load_file('config/single.config.yml')
  all_tests = Test::Unit::TestSuite.new("TestUnit Suite")
  populate_tests(config, all_tests)
  Test::Unit::UI::Console::TestRunner.run(all_tests)
end

task :local do |t, args|
  puts "Running Local Tests"
  bs_local = BrowserStack::Local.new
  config = YAML.load_file('config/local.config.yml')
  all_tests = Test::Unit::TestSuite.new("TestUnit Suite")

  bs_local = BrowserStack::Local.new
  bs_local_args = { "key" => ENV['BROWSERSTACK_ACCESS_KEY'] || config['key'] }
  bs_local.start(bs_local_args)

  populate_tests(config, all_tests, LocalTest)
  Test::Unit::UI::Console::TestRunner.run(all_tests)

  bs_local.stop
end

task :parallel do |t, args|
  puts "Running Parallel Tests"
  num_parallel = 4

  config = YAML.load_file('config/parallel.config.yml')
  all_tests = []
  populate_tests(config, all_tests)

  Parallel.map([*0..(all_tests.size - 1)], :in_processes => num_parallel) do |task_id|
    Test::Unit::UI::Console::TestRunner.run(( Test::Unit::TestSuite.new("TestUnit Suite") << all_tests[task_id] ))
  end
end

task :test do |t, args|
  Rake::Task["single"].invoke
  Rake::Task["local"].invoke
  Rake::Task["parallel"].invoke
end
