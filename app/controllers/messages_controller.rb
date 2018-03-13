class MessagesController < ApplicationController
  before_action :authenticate_user!
  def index
    chat = Chat.find(params[:chat_id])
    unless chat.users.include? current_user
      render nothing: true, status: :unauthorized
      return 
    end
    limit = 20
    if params[:limit].present?
      limit = params[:limit]
    end
    if params[:from_msg_id].present?
      @messages = chat.messages.order(id: :desc).limit(limit).where("id < ?", params[:from_msg_id]).reverse
    else
      @messages = chat.messages.order(id: :desc).limit(limit).reverse
    end
    
    respond_to do |format| 
      format.json
    end
  end
end
