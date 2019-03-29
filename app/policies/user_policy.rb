class UserPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def show?
    true
  end

  def owner_update?
    true
  end

  def have_friendships?
    record.friendships.present?
  end
end
