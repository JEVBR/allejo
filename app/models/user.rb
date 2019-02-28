class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable

  mount_uploader :photo, PhotoUploader

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :pitches, dependent: :destroy
  has_many :bookings, dependent: :destroy
  has_many :participants

  has_many :friends, :foreign_key => 'friend_id'

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :phone, presence: true
  validates :address, presence: true
  # validates :cpf, presence: true
end
