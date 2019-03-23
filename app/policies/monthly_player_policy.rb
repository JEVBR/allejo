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
end
