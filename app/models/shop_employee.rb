class ShopEmployee < ApplicationRecord
  belongs_to :user
  belongs_to :shop
  has_many :details_of_works, inverse_of: :shop_employee
  has_many :product_works, through: :details_of_works
  enum role: { owner: 0, employee: 1, custom: 2 }

  before_save :check_shop_to_employee

  def check_shop_to_employee
    if if_user_is_employee_in_shop && if_user_is_only_owner_in_shop
      true
    else
      error_log
      throw(:abort)
    end
  end

  def error_log
    errors.full_messages.each do |error_message|
      Rails.logger.error "ShopEmployee Error: #{error_message}"
    end
  end

  def if_user_is_employee_in_shop
    if new_record? && shop.users.include?(user)
      errors.add(:abort, 'Shop already has this user as an employee or owner')
      false
    else
      true
    end
  end

  def if_user_is_only_owner_in_shop
    if persisted? && role == 'employee' && shop.owners.include?(user) && shop.owners.count == 1
      errors.add(:abort, 'this user is the only owner of this shop add another owner before changing the role')
      false
    else
      true
    end
  end
end
