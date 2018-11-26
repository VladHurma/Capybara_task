$LOAD_PATH.unshift(".")

require 'selenium-webdriver'
require 'nokogiri'
require 'capybara'

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
		@valid_hrefs = []
		@links
	end
	def self.run
		new.run
	end
	def run
		get_links_from_onliner
		links_sort_and_clean_up
	end

	private

	def get_links_from_onliner
		@browser.visit "https://www.onliner.by/"

		uri = URI("https://www.onliner.by/")
		body = Net::HTTP.get(uri)

		document = Nokogiri::HTML(body)
		@links = document.css('li a')
	end
end


def links_sort_and_clean_up
	@links.each do |link|
		if link['href'] =~ /people.onliner.by/i ||
			link['href'] =~ /auto.onliner.by/i ||
			link['href'] =~ /tech.onliner.by/i ||
			link['href'] =~ /realt.onliner.by/i
			if link['href'].include? '2018'
				@valid_hrefs << link['href']
			end
		end
	end
	puts @valid_hrefs
end

Capybara_scarper_for_onliner.run