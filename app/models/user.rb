class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable

  mount_uploader :photo, PhotoUploader
  geocoded_by :address

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  belongs_to :position, optional: true

  has_many :pitches, dependent: :destroy
  has_many :bookings, dependent: :destroy
  has_many :participants

  has_many :friendships, foreign_key: :user_id
  has_many :friends, through: :friendships

  has_many :monthly_players, through: :pitches

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :phone, presence: true
  validates :address, presence: true
  # validates :cpf, presence: true
  after_validation :geocode, if: :will_save_change_to_address?

  after_save do
    update_column(:full_name, "#{first_name} #{last_name}")
  end
end
