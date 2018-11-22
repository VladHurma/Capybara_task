require 'nokogiri'
require 'rspec'
require 'net/http'
require 'selenium-webdriver'
require 'capybara-screenshot/rspec'
require 'pry'

Capybara::Screenshot.autosave_on_failure = false


uri = URI("https://www.onliner.by/")
body = Net::HTTP.get(uri)

document = Nokogiri::HTML(body)
links = document.css('li a')

links.each do |link|
	puts link.text, " #{link['href']} ", "\n"
end
