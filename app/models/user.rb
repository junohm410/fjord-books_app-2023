class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :zip_code, numericality: { only_integer: true }, length: { is: 7 }, allow_nil: true
  validates :profile, length: { maximum: 200 }
end
