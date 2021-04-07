require 'rails_helper'

RSpec.describe 'Sessions', type: :request do
  let(:user) { FactoryBot.create(:user) }

  describe '#new' do
    it '正しいレスポンスが返ってくること' do
      get login_path
      expect(response).to have_http_status(:success)
    end
  end

  describe '#create' do
    context '無効な情報' do
      it 'ログインできない' do
        post login_path, params: { session: { email: user.email, password: '  ' } }
        expect(logged_in_user?).to be_falsey
      end
    end
  end

  describe '有効な情報でログインして、ログアウトする' do
    it '有効な情報でログインする' do
      post login_path, params: { session: { email: user.email, password: user.password } }
      expect(logged_in_user?).to be_truthy
    end

    it 'ログアウトする' do
      delete logout_path
      expect(logged_in_user?).to be_falsey
    end
  end
end
