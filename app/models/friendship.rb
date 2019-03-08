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

  def self.friends?(user1, user2)
    return true if user1 == user2

    Friendship.where(user_id: user1.id, friend_id: user2.id).present?
  end
end
