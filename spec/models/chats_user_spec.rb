require 'rails_helper'

RSpec.describe ChatsUser, type: :model do
  it { should belong_to :chat }
  it { should belong_to :user }
end
