require 'rails_helper'

RSpec.describe Micropost, type: :model do
  let(:user) { FactoryBot.create(:user) }

  context 'contentとuserが有効な場合' do
    it '有効' do
      micropost = FactoryBot.build(:micropost, content: 'memo', user_id: user.id)
      expect(micropost.valid?).to be_truthy
    end
  end

  context '最新のものが最初にくる' do
    it '最初' do
      10.times do
        FactoryBot.create(:micropost)
      end
      first_micropost = FactoryBot.create(:micropost)
      expect(first_micropost).to eq Micropost.first
    end
  end

  context 'ユーザーを削除' do
    it 'マイクロポストも削除される' do
      FactoryBot.create(:micropost, user: user)
      expect do
        user.destroy
      end.to change(Micropost, :count).by(-1)
    end
  end

  describe 'user_id' do
    context 'nilの時' do
      it '無効' do
        micropost = FactoryBot.build(:micropost, user_id: nil)
        micropost.valid?
        # expect(micropost.errors[:user_id]).to include('must exist')
        expect(micropost.errors).to be_of_kind(:user_id, :blank)
      end
    end
  end

  describe 'content' do
    context '空白の時' do
      it '無効' do
        micropost = FactoryBot.build(:micropost, content: ' ')
        micropost.valid?
        expect(micropost.errors).to be_of_kind(:content, :blank)
      end
    end

    context '141文字の時' do
      it '無効' do
        micropost = FactoryBot.build(:micropost, content: 'a' * 141)
        micropost.valid?
        expect(micropost.errors).to be_of_kind(:content, :too_long)
      end
    end
  end
end
