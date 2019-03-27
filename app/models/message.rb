# app/models/message.rb
class Message < ApplicationRecord
  after_create :broadcast_message
  # ...

  def broadcast_message
    ActionCable.server.broadcast("pingPong", {
      message_partial: ApplicationController.renderer.render(
        partial: "messages/message",
        locals: { message: self, user_is_messages_author: false }
      ),
      current_user_id: user.id
    })
  end
end
