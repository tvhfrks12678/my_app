require 'rails_helper'

RSpec.describe 'Users', type: :request do
  let(:base_title) { 'Ruby on Rails Tutorial Sample App' }
  describe 'GET /new' do
    it 'returns http success' do
      get signup_path
      expect(response).to have_http_status(:success)
      expect(response.body).to include "Sign up | #{base_title}"
    end
  end
end
