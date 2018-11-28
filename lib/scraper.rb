# frozen_string_literal: true

$LOAD_PATH.unshift('.')

require 'selenium-webdriver'
require 'nokogiri'
require 'capybara'
require 'csv_maker'
require 'content_getter'

class Capybara_scarper_for_onliner
  def initialize
    Selenium::WebDriver::Chrome.driver_path = '/home/hurma/prog/Capybara_task/chromedriver'

    Capybara.register_driver :selenium do |app|
      Capybara::Selenium::Driver.new(app, browser: :chrome)
    end

    Capybara.javascript_driver = :chrome
    Capybara.configure do |config|
      config.default_max_wait_time = 10 # seconds
      config.default_driver = :selenium
    end

    # Visit
    @browser = Capybara.current_session
    @driver = @browser.driver.browser
    @content = []
  end

  def self.run
    new.run
  end

  def run
    content_get = Content_getter.new(@browser)
    @content = content_get.run
    CSV_maker.write_to_csv(@content)
  end
end

Capybara_scarper_for_onliner.run
