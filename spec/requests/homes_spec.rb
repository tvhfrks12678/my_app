require 'rails_helper'

RSpec.describe 'Homes', type: :request do
  describe '#home' do
    it 'homeにアクセスした場合に正常なレスポンスを返すこと' do
      get static_pages_home_url
      expect(response).to be_successful
      expect(response).to have_http_status(200)
    end
    it 'helpにアクセスした場合に正常なレスポンスを返すこと' do
      get static_pages_help_url
      expect(response).to be_successful
      expect(response).to have_http_status(200)
    end
    it 'aboutにアクセスした場合に正常なレスポンスを返すこと' do
      get static_pages_about_url
      expect(response).to be_successful
      expect(response).to have_http_status(200)
    end
  end
end
