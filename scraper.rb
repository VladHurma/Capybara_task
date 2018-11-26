$LOAD_PATH.unshift(".")

require 'selenium-webdriver'
require 'nokogiri'
require 'capybara'
require 'csv'

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
		@content = []
		@links
	end
	def self.run
		new.run
	end
	def run
		get_links_from_onliner
		links_sort_and_clean_up
		show_links_list
		@valid_hrefs.each do |link|
			get_news_content(link)
		end
		write_to_csv
	end

	private

	def get_links_from_onliner
		@browser.visit "https://www.onliner.by/"

		uri = URI("https://www.onliner.by/")
		body = Net::HTTP.get(uri)

		document = Nokogiri::HTML(body)
		@links = document.css('li a')
	end
	def links_sort_and_clean_up
		@links.each do |link|
			if link['href'] =~ /people.onliner.by/i ||
				link['href'] =~ /auto.onliner.by/i ||
				link['href'] =~ /tech.onliner.by/i ||
				link['href'] =~ /realt.onliner.by/i
				if (link['href'].include? '2018') & (!link['href'].include? '#comments')
					@valid_hrefs << link['href']
				end
			end
		end
		@valid_hrefs.uniq!.sort!
	end
	def show_links_list
		puts @valid_hrefs
	end
	def get_news_header(link)
			header = @browser.find('.news-posts').find('.news-header__title').text
			header
	end
	def get_news_body(link)
			path = @browser.find('.news-posts').find('.news-text')
			body = ''
			path.all('p').each do |p|
				body += p.text if body.size < 200
			end
			body
	end
	def get_news_content(link)
		@browser.visit(link)
		@content << link
		@content << get_news_header(link)
		@content << get_image(link)
		@content << get_news_body(link)
	end
	def write_to_csv
		CSV.open("./news.csv", "wb") do |csv|
			csv << ['Link', 'Header', 'Image', 'Body']
			while !@content.empty?
				csv << @content.shift(4)
			end
		end
	end
	def get_image(link)
		img = @browser.find('.news-posts').find('.news-header__image').native
             .css_value("background-image").gsub('url("', "").gsub('")', "")
        img
	end
end


Capybara_scarper_for_onliner.run