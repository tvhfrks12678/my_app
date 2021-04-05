require 'rails_helper'

RSpec.describe 'Homes', type: :system do
  scenario 'homeにアクセスする' do
    visit static_pages_home_path
    # visit static_pages_home_url
  end
end
