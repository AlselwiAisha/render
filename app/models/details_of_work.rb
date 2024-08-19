class DetailsOfWork < ApplicationRecord
  belongs_to :shop_employee
  belongs_to :product_work

  before_save :price_update, unless: :saved_change_to_price?

  validates :count, numericality: { greater_than: 0 }
  validates :percent_done, numericality: { greater_than_or_equal_to: 0 }

  enum percent_done: %i[1 0.75 0.5 0.25 0]

  def shop
    shop_employee.shop
  end

  def price_update
    percent_value = percent_done.to_f
    self.price = product_work.product.price * count * product_work.percent * percent_value
  end
end
