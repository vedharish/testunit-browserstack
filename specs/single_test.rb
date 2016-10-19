require 'rubygems'
require 'selenium-webdriver'
require 'test/unit'
 
class SingleTest < Test::Unit::TestCase
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
    @driver.navigate.to "http://www.google.com/ncr"
    element = @driver.find_element(:name, 'q')
    element.send_keys "BrowserStack"
    element.submit
    assert_match(/Google/i, @driver.title)
  end
 
  def teardown
    @driver.quit
  end
end
