class User < ApplicationRecord
  encrypts :jti
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  has_many :shop_employees, inverse_of: :user, dependent: :destroy
  # has_many :employee_shops, through: :employees, class_name: 'Shop', foreign_key: 'employee_id'

  has_many :shops, through: :shop_employees, class_name: 'Shop', foreign_key: 'shop_employee_id'

  include Devise::JWT::RevocationStrategies::JTIMatcher
  devise :registerable, :recoverable, :rememberable, :validatable, :database_authenticatable,
         :jwt_authenticatable, :confirmable, jwt_revocation_strategy: self

  validates :name, presence: true, length: { minimum: 3 }
  validates :password, presence: true, length: { minimum: 6 }
end
