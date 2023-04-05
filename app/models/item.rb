class Item < ApplicationRecord
  has_many :inventory_items
  has_many :inventorys, through: :inventory_items
end
