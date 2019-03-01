class ParticipantPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def logged_in?
    !user.nil?
  end

  def create?
    logged_in?
  end

  def new?
    create?
  end

  def change_confirm?
    record.user == user
  end

  def confirmed?
    record.confirmed == true
  end

  def current_user?
    record.user == user
  end
end
