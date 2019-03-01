class BookingPolicy < ApplicationPolicy
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

  def show?
    true
  end

  def organizer?
    record.user == user
  end
end
