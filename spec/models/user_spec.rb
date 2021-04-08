require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user_valid) { FactoryBot.build(:user) }

  context 'ユーザーの情報が正常な時' do
    it '有効' do
      expect(user_valid).to be_valid
    end
  end

  describe '名前' do
    context '空白の時' do
      it '無効' do
        user = FactoryBot.build(:user, name: '   ')
        user.valid?
        expect(user.errors).to be_of_kind(:name, :blank)
      end
    end

    context '51文字の時' do
      it '無効' do
        user = FactoryBot.build(:user, name: 'a' * 51)
        user.valid?
        expect(user.errors).to be_of_kind(:name, :too_long)
      end
    end
  end

  describe 'メール' do
    context '空白の時' do
      it '無効' do
        user = FactoryBot.build(:user, email: '   ')
        user.valid?
        expect(user.errors).to be_of_kind(:email, :blank)
      end
    end

    context '256文字の時' do
      it '無効' do
        user = FactoryBot.build(:user, email: format('%s@example.com', 'a' * 244))
        user.valid?
        expect(user.errors).to be_of_kind(:email, :too_long)
      end
    end

    context '正しい形式の時' do
      it '有効' do
        valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org
                             first.last@foo.jp alice+bob@baz.cn]
        valid_addresses.each do |valid_address|
          user = FactoryBot.build(:user, email: valid_address)
          user.valid?
          expect(user.errors).to_not be_of_kind(:email, :invalid), "#{valid_address}は有効でないといけない"
        end
      end
    end

    context '不正な形式の時' do
      it '無効' do
        valid_addresses = %w[user@example,com USERfoo.COM A_US-ER@foo_bar.org
                             first.last@foo_jp alice+bob@a+baz.cn foo@bar..com alice+bob@a+baz.cn]

        users = valid_addresses.map { |valid_address| FactoryBot.build(:user, email: valid_address) }

        aggregate_failures do
          users.each do |user|
            user.valid?
            expect(user.errors).to be_of_kind(:email, :invalid), "#{user.email}は無効でないといけない"
          end
        end
      end
    end

    context '重複したメールの時' do
      it '無効' do
        FactoryBot.create(:user, email: 'same3@example.com')
        user = FactoryBot.build(:user, email: 'same3@example.com')
        user.valid?
        expect(user.errors).to be_of_kind(:email, :taken)
      end
    end

    context '大文字が混ざったメールで登録された時' do
      it 'メールは小文字で保存されること' do
        mixed_case_email = 'Foo@ExAMPle.CoM'
        user = FactoryBot.create(:user, email: mixed_case_email)
        expect(user.reload.email).to eq mixed_case_email.downcase
      end
    end
  end

  context 'パスワード' do
    it '空白の時は無効' do
      user = FactoryBot.build(:user, password: ' ' * 6, password_confirmation: ' ' * 6)
      user.valid?
      expect(user.errors).to be_of_kind(:password, :blank)
    end

    it '5文字の時は無効' do
      user = FactoryBot.build(:user, password: 'a' * 5, password_confirmation: 'a' * 5)
      user.valid?
      expect(user.errors).to be_of_kind(:password, :too_short)
    end
  end

  describe '#authenticated?' do
    context 'remember_digestがnillの時' do
      it 'falseをリターンする' do
        user = FactoryBot.build(:user, remember_token: nil)
        expect(user.authenticated?('')).to be_falsey
      end
    end
  end
end
