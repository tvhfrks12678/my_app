require 'rails_helper'

# Specs in this file have access to a helper object that includes
# the SessionsHelper. For example:
#
# describe SessionsHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
RSpec.describe SessionsHelper, type: :helper do
  # Todo describeは永続的セッションのテストでいいかも？検討する
  describe '#current_user' do
    before do
      @user = FactoryBot.create(:user)
      remember(@user)
    end

    context 'sessionがnilの時' do
      it 'current_userは正しいユーザーをreturnする' do
        expect(@user).to eq current_user
        expect(logged_in_user?).to be_truthy
      end
    end

    context 'remember_digestが誤っている時' do
      it 'nilをreturnする' do
        @user.update_attribute(:remember_digest, User.digest(User.new_token))
        expect(current_user).to be_nil
      end
    end
  end
end
