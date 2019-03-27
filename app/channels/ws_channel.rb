# app/channels/chat_rooms_channel.rb
class WSChannel < ApplicationCable::Channel
  def subscribed
    stream_from specific_channel
  end

  private

  def specific_channel
    "ws_#{params[:user_id]}"
  end
end

