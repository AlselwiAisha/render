class ProductWork < ApplicationRecord
  belongs_to :work
  belongs_to :product
  has_many :details_of_works, inverse_of: :product_work, dependent: :destroy
  has_many :shop_employee, through: :details_of_works

  validates :percent, presence: true, numericality: { greater_than: 0 }

  def shop
    product.shop
  end
end
