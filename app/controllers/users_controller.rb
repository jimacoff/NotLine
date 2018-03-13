class UsersController < ApplicationController
  before_action :authenticate_user!, only: [:chat]
  def index
    @users = User.order(name: :asc).page(params[:page]).per(20)
  end

  def show
    @user = User.find(params[:id])
  end

  def chat
    partner = User.find(params[:id])
    chat = current_user.find_or_create_chat_with(User.find(params[:id]))
    redirect_to chats_path(initial_chat: chat.id)
  end
end
