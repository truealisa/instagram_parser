require 'rails_helper'

RSpec.describe LocationScraper do
  describe '#initialize' do
    let(:credentials) { { email: 'test@email.com', password: 'test_password' } }
    let(:instagram_url) { 'https://www.instagram.com/' }
    let(:instagram_post_url) { 'https://www.instagram.com/p/' }

    it 'loads instagram credentials from config' do
      expect(subject.instance_variable_get(:@credentials)).to eq(credentials)
    end

    it 'runs selenium web driver with firefox' do
      expect(subject.instance_variable_get(:@browser))
        .to be_kind_of(Selenium::WebDriver::Firefox::Marionette::Driver)
    end

    it 'has correct @base_url variable' do
      expect(subject.instance_variable_get(:@base_url)).to eq(instagram_url)
    end

    it 'has correct @post_url variable' do
      expect(subject.instance_variable_get(:@post_url)).to eq(instagram_post_url)
    end

    it 'has @usernames variable which is an empty array' do
      expect(subject.instance_variable_get(:@usernames)).to eq([])
    end

    it 'has @post_links variable which is an empty array' do
      expect(subject.instance_variable_get(:@post_links)).to eq([])
    end
  end
end
