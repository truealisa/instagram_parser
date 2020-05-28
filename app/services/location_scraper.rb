require 'open-uri'
require 'csv'

class LocationScraper
  attr_reader :credentials, :browser, :base_url, :post_url, :usernames, :post_links

  def initialize
    @credentials = Rails.application.config_for(:instagram_credentials)
    @browser = Selenium::WebDriver.for :firefox, options: selenium_options
    @base_url = 'https://www.instagram.com/'
    @post_url = base_url + 'p/'
    @usernames = []
    @post_links = []
  end

  def fetch_usernames
    login
    browser.get(Location.last.link)
    puts 'Fetching last 100 unique usernames. Please wait, this may take a while'
    collect_usernames while usernames.size < 100
    browser.quit
    save_to_csv
  end

  private

  def selenium_options
    Selenium::WebDriver::Firefox::Options.new(args: ['--headless'])
  end

  def login
    browser.get(base_url)
    wait = Selenium::WebDriver::Wait.new(timeout: 15)
    username_input = wait.until do
      element = browser.find_element(:name, "username")
      element if element.displayed?
    end
    username_input.send_keys(credentials[:email])
    password_input = browser.find_element(:name, "password")
    password_input.send_keys(credentials[:password], :return)
    sleep 10
  end

  def collect_usernames
    links = browser.find_elements(xpath: '//a').map { |elem| elem.attribute('href') }
    links.each do |link|
      if link.include?(post_url) && post_links.exclude?(link)
        post_links << link
        username = get_username(link)
        usernames << username if usernames.exclude?(username)
        print '.'
      end
    end
    browser.execute_script(js_scroll_down)
    sleep 10
  end

  def get_username(link)
    doc = Nokogiri::HTML(open(link))
    description = doc.at_css('meta[property="og:description"]')['content']
    description[/@(\w|\.)+/].delete_prefix('@')
  end

  def js_scroll_down
    "window.scrollTo(0, document.body.scrollHeight);"
  end

  def save_to_csv
    Dir.mkdir 'storage/csv' unless Dir.exist? 'storage/csv'
    File.open("storage/csv/#{Time.current.to_s(:number)}.csv", 'w') do |file|
      file.write(usernames[0...100].to_csv)
    end
  end
end
