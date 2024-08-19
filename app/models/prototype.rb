class Prototype < ApplicationRecord
  belongs_to :group
  has_many :products, dependent: :destroy

  validates :name, presence: true, length: { minimum: 3 }

  def check_to_delete
    return unless products.empty?

    destroy
    group.check_to_delete
  end
end
