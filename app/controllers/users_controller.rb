class UsersController < ApplicationController
  before_action :authenticate_user!, only: [:chat]
  def index
    @users = User.order(name: :asc).page(params[:page]).per(20)
  end

  def show
    @user = User.find(params[:id])
  end

  def chat
    chat = current_user.find_or_create_chat_with(User.find(params[:id]))
    redirect_to chat_path(chat)
  end
end
