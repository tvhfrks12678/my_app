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

  describe '#create' do
    context '無効なデータの時' do
      it 'ユーザーのデータが登録されない' do
        get signup_path
        user_registration_data = FactoryBot.attributes_for(:user, name: '', email: 'aa', password: 'b',
                                                                  assword_confirmation: '')
        expect do
          post users_path, params: { user: user_registration_data }
        end.to_not change(User, :count)
        expect(response.body).to include "Sign up | #{base_title}"
      end
    end
  end
end
