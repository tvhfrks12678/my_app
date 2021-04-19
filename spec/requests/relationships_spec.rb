require 'rails_helper'

RSpec.describe 'Relationships', type: :request do
  let(:user) { FactoryBot.create(:user) }
  describe '#create' do
    context 'loginしていない時' do
      it '不可' do
        expect do
          post relationships_path
          expect(response).to redirect_to login_url
        end.to_not change(Relationship, :count)
      end
    end
  end

  describe '#destroy' do
    context 'loginしていない時' do
      it '不可' do
        create_other_user_and_follow(user)
        expect do
          delete relationship_path(Relationship.first)
          expect(response).to redirect_to login_url
        end.to_not change(Relationship, :count)
      end
    end
  end
end
