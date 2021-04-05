require 'rails_helper'

RSpec.describe 'StaticPages', type: :request do
  it 'rootにアクセスした場合に正常なレスポンスを返すこと' do
    get root_url
    expect(response).to be_successful
    expect(response).to have_http_status(200)
  end

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
