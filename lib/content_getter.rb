class Content_getter
	def initialize(browser)
		@browser = browser
		@links
		@content = []
		@valid_hrefs = []
	end
	def run
		get_links_from_onliner
		links_sort_and_clean_up
		@valid_hrefs.each do |link|
			@browser.visit(link)
			get_news_content(link)
		end
		@content
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
	def get_news_content(link)
		@content << link
		@content << get_news_header(link)
		@content << get_image(link)
		@content << get_news_body(link)
	end
	def get_news_header(link)
		header = @browser.find('.news-posts').find('.news-header__title').text
		header
	end
	def get_news_body(link)
		path = @browser.find('.news-posts').find('.news-text')
		body = ''
		path.all('p').each do |p|
			if body.size < 200
				body += p.text
			else
				break
			end
		end
		body
	end
	def get_image(link)
		img = @browser.find('.news-posts').find('.news-header__image').native
             .css_value("background-image").gsub('url("', "").gsub('")', "")
        img
	end
end