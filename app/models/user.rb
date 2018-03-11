class User < ApplicationRecord
  mount_uploader :avatar, AvatarUploader
  validates :name, presence: true
  has_many :chats_users, dependent: :delete_all
  has_many :chats, through: :chats_users

  def find_chat_with(other_user)
    chats.where(id: other_user.chats.select(:id)).first
  end

  def find_or_create_chat_with(other_user)
    chat = find_chat_with(other_user)
    return chat if chat.present?
    chat = chats.create
    chat.users << other_user
    chat.save
    return chat
  end

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
          :rememberable, :trackable, :validatable
end
