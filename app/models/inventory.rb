class Inventory < ApplicationRecord
  belongs_to :user
  has_many :inventory_items, dependent: :destroy
  has_many :items, through: :inventory_items, dependent: :destroy
end
