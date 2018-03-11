class MessagesController < ApplicationController
  def index
    chat = Chat.find(params[:chat_id])
    limit, offset = 20, 0
    if params[:limit].present?
      limit = params[:limit]
    end
    if params[:offset].present?
      offset = params[:offset]
    end
    offset = params[:offset] || 0
    @messages = chat.messages.order(id: :desc).limit(limit).offset(offset).reverse
  end
end
