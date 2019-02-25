class Pitch < ApplicationRecord
  belongs_to :user
  belongs_to :category

  has_many :daily_schedules, dependent: :destroy

  validates :title, presence: true
  validates :subtitle, presence: true

  validates :address, presence: true
  validates :cep, presence: true
  validates :cnpj, presence: true
  validates :price, presence: true
end
