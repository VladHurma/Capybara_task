# frozen_string_literal: true

class Content_getter
  def initialize(browser)
    @browser = browser
    @links = []
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
    @browser.visit 'https://www.onliner.by/'

    @browser.all('a').each do |a_body|
      @links << a_body['href']
    end
  end

  def links_sort_and_clean_up
    @links.each do |link|
      next unless link =~ /people.onliner.by/i ||
                  link =~ /auto.onliner.by/i ||
                  link =~ /tech.onliner.by/i ||
                  link =~ /realt.onliner.by/i

      if (link.include? '2018') & (!link.include? '#comments')
        @valid_hrefs << link
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

  def get_news_header(_link)
    header = @browser.find('.news-posts').find('.news-header__title').text
    header
  end

  def get_news_body(_link)
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

  def get_image(_link)
    img = @browser.find('.news-posts').find('.news-header__image').native
                  .css_value('background-image').gsub('url("', '').gsub('")', '')
    img
  end
end
