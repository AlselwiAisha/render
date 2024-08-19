class Product < ApplicationRecord
  belongs_to :prototype
  belongs_to :shop

  has_many :product_works, inverse_of: :product, dependent: :destroy
  has_many :works, through: :product_works

  validates :name, presence: true, length: { minimum: 3 }
  validates :price, numericality: { greater_than: 0 }

  def group
    prototype.group
  end
end
