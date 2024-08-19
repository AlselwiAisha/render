class Group < ApplicationRecord
  has_many :prototypes, dependent: :destroy

  validates :name, presence: true, length: { minimum: 3 }

  def check_to_delete
    return unless prototypes.empty?

    destroy
  end
end
