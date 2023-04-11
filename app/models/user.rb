class User < ApplicationRecord
  has_one :inventory, dependent: :destroy

  validates :name, presence: true, uniqueness: true
end
