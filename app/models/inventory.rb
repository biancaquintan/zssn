class Inventory < ApplicationRecord
  belongs_to :user
  has_many :inventory_items, dependent: :destroy
  has_many :items, through: :inventory_items, dependent: :destroy

  def self.update(user, inventory, method, item)
    @response= {}
    user_items = inventory.items.to_a
    
    unless user.infection?
      if method === 'add'
        inventory.items.push(item)
      elsif method === 'remove'
        if user_items.include?(item)
          user_items.delete_at(user_items.index(item))
          inventory.update!(items: user_items)
        else
          @response[:error_message] = "This user doesn't have any #{item.name} in inventory to delete."
        end
      else
        @response[:error_message] = "Unexpected method param for this request. You can try 'add' or 'remove' methods."
      end
    else
      @response[:error_message] = "Infected users cannot update inventory."
    end

    @response
  end
end

