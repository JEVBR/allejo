class PitchPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def create?
    user.owner
  end

  def new?
    create?
  end

  def show?
    true
  end

  def owner?
    record.user == user
  end

  def destroy?
    owner?
  end

  def update?
    owner?
  end

  def edit?
    update?
  end

  def map?
    true
  end
end
