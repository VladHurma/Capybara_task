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

puts links

links.each do |link|
	puts "#{link['href']}" + "\n"

	f = File.open 'links.xml', "a"
	f.write "#{links.txt}" + "\n"
	f.close
end