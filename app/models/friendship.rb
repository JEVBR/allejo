class Friendship < ApplicationRecord
  belongs_to :user
  belongs_to :friend, :class_name => 'User'

  validates_uniqueness_of :friend_id, scope: :user_id
  validate :check_friend_user

  def check_friend_user
    if user == friend
      errors.add(:friend, "can't add yourself")
    end
  end
end
