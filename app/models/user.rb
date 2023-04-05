class User < ApplicationRecord
  has_one :inventory, dependent: :destroy
end
