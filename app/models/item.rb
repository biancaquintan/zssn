class Item < ApplicationRecord
  has_many :inventory_items, dependent: :destroy
  has_many :inventorys, through: :inventory_items, dependent: :destroy
end
