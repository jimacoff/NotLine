FactoryBot.define do
  factory :chat do
    sequence(:title) {|n| "chat#{n}"}
  end
end
