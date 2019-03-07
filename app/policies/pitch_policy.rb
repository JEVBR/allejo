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
  
  def day_blocked?(date)
    start_time = date.beginning_of_day + record.opening_time.hours
    end_time = date.beginning_of_day + record.closing_time.hours
    booking = record.bookings.find_by(start_time: start_time, end_time: end_time)

    booking.present? && booking.blocked ? true : false
  end
  
end
