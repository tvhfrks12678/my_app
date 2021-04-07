require 'rails_helper'

RSpec.describe 'Users', type: :request do
  let(:base_title) { 'Ruby on Rails Tutorial Sample App' }
  describe '#new' do
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
        expect(logged_in_user?).to be_falsey
      end
    end

    context '有効なデータの時' do
      it 'ユーザーのデータが登録される' do
        get signup_path
        user_registration_data = FactoryBot.attributes_for(:user)
        expect do
          post users_path, params: { user: user_registration_data }
          aggregate_failures do
            expect(response).to redirect_to user_path(User.last)
            follow_redirect!
            expect(response.body).to include base_title
            expect(flash[:success]).to be_truthy
            expect(logged_in_user?).to be_truthy
          end
        end.to change(User, :count).by(1)
      end
    end
  end
end
