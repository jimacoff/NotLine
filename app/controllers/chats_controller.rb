class ChatsController < ApplicationController
  before_action :authenticate_user!

  def index
    @chats = current_user.chats.order(updated_at: :desc)
  end

  def show
    @chat = Chat.find(params[:id])
    @partner = @chat.partner_of(current_user)
    respond_to do |format|
      format.json
      format.html
    end
  end
end
