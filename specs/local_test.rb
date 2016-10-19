require 'rubygems'
require 'selenium-webdriver'
require 'test/unit'
 
class LocalTest < Test::Unit::TestCase
  @username = ""
  @access_key = ""
  @caps = {}

  def initialize(test_name, options={})
    super(test_name)
    @username ||= options[:username]
    @access_key ||= options[:access_key]
    @caps = options[:caps]
  end

  def setup
    url = "https://#{@username}:#{@access_key}@hub-cloud.browserstack.com/wd/hub"
    @driver = Selenium::WebDriver.for(:remote, :url => url, :desired_capabilities => @caps)
  end
 
  def google_test
    @driver.navigate.to "http://bs-local.com:45691/check"
    assert_match(/Up and running/i, @driver.page_source)
  end
 
  def teardown
    @driver.quit
  end
end
