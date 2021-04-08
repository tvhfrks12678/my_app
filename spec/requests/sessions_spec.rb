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

  it '有効な情報でログインして、ログアウトする' do
    post login_path, params: { session: { email: user.email, password: user.password } }
    expect(logged_in_user?).to be_truthy
    delete logout_path
    expect(logged_in_user?).to be_falsey
    follow_redirect!
    expect(logged_in_user?).to be_falsey
    delete logout_path
  end

  describe '#log_in_success(user)' do
    context 'remember_meでログインした時' do
      it 'cookieにremember_tokenが保存されている' do
        log_in_as(user, remember_me: '1')
        expect(cookies[:remember_token]).to_not be_empty
      end
    end
    context 'remember_meなしでログインした時' do
      it 'cokkieにremember_tokenが保存されていない' do
        # cookieを保存してログイン
        log_in_as(user, remember_me: '1')
        delete logout_path
        # cookieを削除してログイン
        log_in_as(user, remember_me: '0')
        expect(cookies[:remember_token]).to be_empty
      end
    end
  end
end
