require 'rails_helper'

RSpec.describe 'Microposts', type: :request do
  let!(:user) { FactoryBot.create(:user) }
  let!(:other_user) { FactoryBot.create(:user) }
  let!(:micropost) { FactoryBot.create(:micropost) }
  let(:micropost_params) { FactoryBot.attributes_for(:micropost) }

  describe '#create' do
    context 'loginなしで投稿' do
      it '無効' do
        expect do
          post microposts_path, params: { micropost: micropost_params }
        end.to_not change(Micropost, :count)
        expect(response).to redirect_to login_url
      end
    end
  end

  describe '#destroy' do
    context 'loginなしでmicropostを削除' do
      it '無効' do
        expect do
          delete micropost_path(micropost)
        end.to_not change(Micropost, :count)
        expect(response).to redirect_to login_url
      end
    end

    context '間違ったユーザーによるマイクロポスト削除' do
      it 'マイクロポストを削除できない' do
        micropost = FactoryBot.create(:micropost, user: user)
        log_in_as(other_user)
        expect do
          delete micropost_path(micropost)
        end.to_not change(Micropost, :count)
        expect(response).to redirect_to root_url
      end
    end
  end
end
