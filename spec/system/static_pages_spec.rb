require 'rails_helper'

RSpec.describe 'StaticPages', type: :system do
  let(:base_title) { 'Ruby on Rails Tutorial Sample App' }

  scenario 'homeを表示できること' do
    visit static_pages_home_path
    expect(page).to have_title "Home | #{base_title}"
  end

  scenario 'helpを表示できること' do
    visit static_pages_help_path
    expect(page).to have_title "Help | #{base_title}"
  end

  scenario 'aboutを表示できること' do
    visit static_pages_about_path
    expect(page).to have_title "About | #{base_title}"
  end

  scenario 'contactを表示できること' do
    visit static_pages_contact_path
    expect(page).to have_title "Contact | #{base_title}"
  end
end
