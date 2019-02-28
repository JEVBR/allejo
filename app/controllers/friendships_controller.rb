class FriendshipsController < ApplicationController
  def create
    friend = User.find_by(email: params[:email])
    friendship = Friendship.new
    authorize friendship

    if friend.present?
      friendship = Friendship.new(user: current_user, friend_id: friend.id)
    end

    if friendship.valid?
      friendship.save
      redirect_to request.env["HTTP_REFERER"], notice: "#{friend.first_name} #{friend.last_name} foi adicionado a sua lista de amigos"
    else
      redirect_to request.env["HTTP_REFERER"], alert: "#{params[:email]} não foi encontrado"
    end
  end
end
