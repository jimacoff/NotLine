class Chat < ApplicationRecord
  has_many :chats_users, dependent: :delete_all
  has_many :users, through: :chats_users
  has_many :messages

  def partner_of(current_user)
    users.reject {|user| user == current_user }.first
  end
end
