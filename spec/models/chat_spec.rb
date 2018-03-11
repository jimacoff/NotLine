require 'rails_helper'

RSpec.describe Chat, type: :model do
  it { should have_many :chats_users }
  it { should have_many :users }
  it { should have_many :messages }

  describe "#partner_of" do
    let(:current_user) { FactoryBot.create(:user) }
    let(:other_user) { FactoryBot.create(:user) }
    let(:chat) { FactoryBot.create(:chat) }

    it "finds chat partner from current user argument" do
      chat.users = [current_user, other_user]
      expect(chat.partner_of(current_user)).to eq(other_user)
    end
  end
end
