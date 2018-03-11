class ChatChannel < ApplicationCable::Channel
  def subscribed
    chat = Chat.find(params[:chat_id])
    unless chat.users.include? current_user
      reject_unauthorized_connection
    end
    stream_from "chat-#{chat.id}"
  end

  def receive(data)
    chat = Chat.find(params[:chat_id])
    unless data['sender_id'] == current_user.id && data['recipient_id'] == chat.partner_of(current_user).id
      reject_unauthorized_connection
    end
    message = chat.messages.build(data.symbolize_keys)
    message.save
    data['sent_at'] = message.created_at.iso8601
    ActionCable.server.broadcast("chat-#{chat.id}", data)
    chat.users.each do |user|
      ActionCable.server.broadcast("user-#{user.id}", data)
    end
  end
end
