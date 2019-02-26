class Pitch < ApplicationRecord
  belongs_to :user
  belongs_to :category

  has_many :bookings, dependent: :destroy

  validates :category, presence: true
  validates :user, presence: true

  validates :title, presence: true
  validates :subtitle, presence: true

  validates :address, presence: true
  validates :cep, presence: true
  validates :cnpj, presence: true
  validates :price, presence: true
end
