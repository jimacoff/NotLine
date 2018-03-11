require 'rails_helper'

RSpec.describe User, type: :model do
  it { should validate_presence_of :name }
  it { should have_many :chats_users }
  it { should have_many :chats }

  context "Chat" do
    let(:chats) { FactoryBot.create_list(:chat, 2) }
    let(:users) { FactoryBot.create_list(:user, 3) }

    before(:each) do
      chats[0].users = [users[0], users[1]]
      chats[1].users = [users[0], users[2]]
    end

    describe "#find_chat_with" do
      it "finds chat by two users" do
        expect(users[0].find_chat_with(users[1])).to eq(chats[0])
      end

      it "returns nil if no such chat" do
        expect(users[1].find_chat_with(users[2])).to eq(nil)
      end
    end

    describe "#find_or_create_chat_with" do
      it "creates Chat along with two users if no existing one" do
        chat = users[1].find_or_create_chat_with(users[2])
        expect(chat.users).to include(users[1])
        expect(chat.users).to include(users[2])
      end

      it "returns existing Chat of two users" do
        chat = users[0].find_or_create_chat_with(users[2])
        expect(chat).to eq(chats[1])
      end
    end
  end
end
