class UserChannel < ApplicationCable::Channel
  def subscribed
    user = User.find(params[:id])
    unless user == current_user
      reject_unauthorized_connection
    end
    stream_from "user-#{user.id}"
  end
end
