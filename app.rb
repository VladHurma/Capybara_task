require "nokogiri"
require "net/http"
require "selenium-webdriver"

uri = URI("https://www.onliner.by/")
body = Net::HTTP.get(uri)

document = Nokogiri::HTML(body)
links = 