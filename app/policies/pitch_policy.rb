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
end
