class Category < ApplicationRecord
  has_many :pitches

  validates :name, presence: true
  validates :name, uniqueness: true
end
