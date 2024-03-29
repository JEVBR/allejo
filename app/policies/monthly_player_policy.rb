class MonthlyPlayerPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def create?
    pitch = Pitch.find(record.pitch_id)
    pitch.user == user
  end

  def new?
    user.owner?
  end

  def destroy?
    create?
  end

  def edit?
    create?
  end

  def update?
    edit?
  end
end
