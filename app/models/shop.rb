class Shop < ApplicationRecord
  has_many :works
  has_many :shop_employees, dependent: :destroy, inverse_of: :shop
  has_many :products, dependent: :destroy

  has_many :users, through: :shop_employees
  has_many :shop_owner_records, -> { where role: 'owner' }, class_name: 'ShopEmployee'
  has_many :owners, through: :shop_owner_records, source: :user
  has_many :employee_records, -> { where role: 'employee' }, class_name: 'ShopEmployee'
  has_many :employees, through: :employee_records, source: :user

  validates :name, presence: true, length: { minimum: 3 }
end
