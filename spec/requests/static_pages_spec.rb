require 'rails_helper'

RSpec.describe 'StaticPages', type: :request do
  let(:base_title) { 'Ruby on Rails Tutorial Sample App' }

  describe '#home' do
    context 'アクセスした時' do
      it 'Titleが正しく表示されること' do
        get root_path
        expect(response).to be_successful
        expect(response).to have_http_status(200)
        expect(response.body).to include base_title
        expect(response.body).to_not include '|'
      end
    end
  end

  describe '#help' do
    context 'アクセスした時' do
      it 'Titleが正しく表示されること' do
        get help_path
        expect(response).to be_successful
        expect(response).to have_http_status(200)
        expect(response.body).to include "Help | #{base_title}"
      end
    end
  end

  describe '#about' do
    context 'アクセスした時' do
      it 'Titleが正しく表示されること' do
        get about_path
        expect(response).to be_successful
        expect(response).to have_http_status(200)
        expect(response.body).to include "About | #{base_title}"
      end
    end
  end

  describe '#contact' do
    context 'アクセスした時' do
      it 'Titleが正しく表示されること' do
        get contact_path
        expect(response).to be_successful
        expect(response).to have_http_status(200)
        expect(response.body).to include "Contact | #{base_title}"
      end
    end
  end
end
