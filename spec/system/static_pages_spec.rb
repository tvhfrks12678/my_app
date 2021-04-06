require 'rails_helper'

RSpec.describe 'StaticPages', type: :system do
  let(:base_title) { 'Ruby on Rails Tutorial Sample App' }

  scenario 'ヘッダーとフッターが正しく表示されること' do
    visit root_path
    expect(page.title).to eq base_title
    aggregate_failures do
      expect(page).to have_link 'Home', href: root_path
      expect(page).to have_link 'sample app', href: root_path
      expect(page).to have_link 'Help', href: help_path
      expect(page).to have_link 'About', href: about_path
      expect(page).to have_link 'Contact', href: contact_path
    end
  end
end
