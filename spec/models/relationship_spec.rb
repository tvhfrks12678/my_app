require 'rails_helper'

RSpec.fdescribe Relationship, type: :model do
  let(:user) { FactoryBot.create(:user) }
  let(:other_user) { FactoryBot.create(:user) }
  # let(:relationship) { FactoryBot.build(:relationship, follower_id: user.id, followed_id: other_user.id) }

  it '有効な値' do
    relationship = user.active_relationships.build(followed_id: other_user.id)
    expect(relationship.valid?).to be_truthy
  end

  describe 'follower_id' do
    context 'nil' do
      it '無効 Relationship.new' do
        # relationship = user.active_relationships.build(followed_id: other_user.id)
        relationship = Relationship.new(follower_id: nil, followed_id: other_user.id)
        relationship.valid?
        expect(relationship.errors).to be_of_kind(:follower, :blank)
      end
    end
  end

  describe 'followed_id' do
    context 'nil' do
      it '無効' do
        relationship = user.active_relationships.build(followed_id: other_user.id)
        relationship.followed_id = nil
        expect(relationship).to be_invalid
      end
    end
  end
end
