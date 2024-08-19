class Work < ApplicationRecord
  belongs_to :shop
  has_many :product_works, inverse_of: :work, dependent: :destroy
  has_many :products, through: :product_works

  validates :name, presence: true, length: { minimum: 2 }
end
