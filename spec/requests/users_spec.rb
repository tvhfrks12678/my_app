require 'rails_helper'

RSpec.describe 'Users', type: :request do
  let(:base_title) { 'Ruby on Rails Tutorial Sample App' }
  let(:admin_user) { FactoryBot.create(:user, admin: true) }
  let(:user) { FactoryBot.create(:user) }
  let(:other_user) { FactoryBot.create(:user) }
  let(:not_activated_user) { FactoryBot.create(:user, activated: false) }
  let(:user_params) { FactoryBot.attributes_for(:user) }

  describe '#index' do
    context 'ログインせずにGETした時' do
      it 'loginページにリダイレクトされる' do
        get users_path

        expect(response).to redirect_to login_url
      end
    end
  end

  describe '#show' do
    context 'メールでアクティベートしていないユーザーにアクセスした時' do
      it 'rootにリダイレクトされる' do
        get user_path(not_activated_user)
        expect(response).to redirect_to root_url
      end
    end
  end

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
                                                                  password_confirmation: '')
        expect do
          post users_path, params: { user: user_registration_data }
        end.to_not change(User, :count)
        expect(response.body).to include "Sign up | #{base_title}"
        expect(logged_in_user?).to be_falsey
      end
    end

    context '有効なデータの時' do
      it 'ユーザーのデータが登録され、アクティベート後、ログインできる' do
        ActionMailer::Base.deliveries.clear
        get signup_path
        user_params = FactoryBot.attributes_for(:user)
        expect do
          post users_path, params: { user: user_params }
          aggregate_failures do
            expect(response).to redirect_to root_url
            follow_redirect!
            expect(response.body).to include base_title
            expect(flash[:info]).to be_truthy
            expect(logged_in_user?).to be_falsey
          end
        end.to change(User, :count).by(1)
        expect(ActionMailer::Base.deliveries.size).to eq 1
        user = User.find_by(email: user_params[:email])
        expect(user).to_not be_activated
        expect(logged_in_user?).to be_falsey
        # 有効化していない状態でログインしてみる
        log_in_as(user)
        expect(logged_in_user?).to be_falsey
        # 有効化トークンが不正な場合
        get edit_account_activation_path('invalid token', email: user.email)
        mail_body = ActionMailer::Base.deliveries.last.html_part.body.raw_source.to_s
        user_activation_token = mail_body.match(%r{account_activations/(.+?)/})[1]
        get edit_account_activation_path(user_activation_token, email: 'wrong')
        expect(logged_in_user?).to be_falsey
        # トークンは正しいがメールアドレスが無効な場合
        get edit_account_activation_path(user_activation_token, email: 'wrong')
        expect(logged_in_user?).to be_falsey
        # 有効化トークンが正しい場合
        get edit_account_activation_path(user_activation_token, email: user.email)
        expect(response).to redirect_to user_path(user)
        expect(user.reload.activated?).to be_truthy
        expect(logged_in_user?).to be_truthy
      end
    end
  end

  describe '#edit' do
    context 'loginしていない状態でアクセスした時' do
      it '不可' do
        get edit_user_path(user)
        expect(response).to redirect_to login_url
        expect(flash[:danger]).to be_truthy
      end
    end

    context '間違ったユーザーが編集しようとした時' do
      it '不可' do
        log_in_as(other_user)
        get edit_user_path(user)
        expect(flash).to be_empty
        expect(response).to redirect_to root_url
      end
    end
  end

  describe '#update' do
    context 'loginせずに更新処理した時' do
      it '更新不可' do
        patch user_path(user), params: { user: user_params }
        expect(response).to redirect_to login_url
        expect(flash[:danger]).to be_truthy
      end
    end

    context '間違ったユーザーが編集しようとした時' do
      it '更新不可' do
        log_in_as(other_user)
        patch user_path(user), params: { user: user_params }
        expect(flash).to be_empty
        expect(response).to redirect_to root_url
      end
    end

    context '無効な情報で更新した時' do
      it '更新不可' do
        log_in_as(user)
        get edit_user_path(user)

        expect(response.body).to include 'Update your profile'
        patch user_path(user),
              params: { user: { name: '', email: 'foo@invalid', password: 'foo', password_confirmation: 'bar' } }
        expect(response.body).to include 'Update your profile'
        expect(flash[:success]).to be_falsey
      end
    end

    context 'web経由でadmin属性を更新する時' do
      it 'admin属性を更新できない' do
        user = FactoryBot.create(:user, admin: false)
        log_in_as(user)
        expect(user).to_not be_admin
        patch user_path(user),
              params: { user: { password: user.password, password_confirmation: user.password_confirmation,
                                admin: true } }
        expect(user.reload).to_not be_admin
      end
    end
  end

  describe '#destroy' do
    context 'ログインせずにユーザーを削除する時' do
      it 'ユーザーの削除不可' do
        user = FactoryBot.create(:user)
        expect do
          delete user_path(user)
          expect(response).to redirect_to login_url
        end.to_not change(User, :count)
      end
    end

    context '管理者権限を持たないユーザーがログインして、ユーザーを削除する時' do
      it 'ユーザーの削除不可' do
        log_in_as(user)
        expect do
          delete user_path(user)
          expect(response).to redirect_to root_url
        end.to_not change(User, :count)
      end
    end
  end
end
