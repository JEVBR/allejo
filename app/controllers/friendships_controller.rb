class FriendshipsController < ApplicationController
  def create
    friend = User.find_by(email: params[:email])
    friendship = Friendship.new
    friendship2 = Friendship.new

    authorize friendship
    authorize friendship2

    if friend.present?
      friendship = Friendship.new(user: current_user, friend_id: friend.id, name: "#{friend.full_name}")
      friendship2 = Friendship.new(user: friend, friend_id: current_user.id, name: "#{current_user.full_name}")
    end

    if friendship.valid? && friendship2.valid?
      friendship.save
      friendship2.save
      redirect_to request.env["HTTP_REFERER"], notice: "#{friend.full_name} foi adicionado a sua lista de amigos"
    else
      redirect_to request.env["HTTP_REFERER"], alert: "#{params[:email]} não foi encontrado ou já adicionado"
    end
  end
end
