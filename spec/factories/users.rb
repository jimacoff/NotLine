FactoryBot.define do
  factory :user do
    sequence(:email) {|n| "user#{n}@notline.tw"}
    password "test5566"
    sequence(:name) {|n| "User#{n}"}
  end
end
