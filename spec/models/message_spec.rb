require 'rails_helper'

RSpec.describe Message, type: :model do
  it { should belong_to(:chat) }
  it { should belong_to(:sender).class_name("User") }
  it { should belong_to(:recipient).class_name("User") }
end
