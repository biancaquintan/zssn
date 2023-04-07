class Api::V1::FirstZombieApocalypsesController < ApplicationController
  before_action :set_user, :set_inventory, only: [:update_location, :update_inventory]

  # POST /api/v1/users/register
  def register_user
    @user = User.new(user_params)
    
    if @user.save
      @inventory = Inventory.new(user_id: @user.id)
      if @inventory.save
        render json: @user, status: :created
      else
        render json: @inventory.errors, status: :unprocessable_entity
      end
    else
      render json: @user.errors, status: :unprocessable_entity
    end

  end
  
  # PATCH/PUT /api/v1/users/:id/update_location
  def update_location
    if @user.update(last_location: params[:last_location])
      render json: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end
  
  # PATCH/PUT /api/v1/users/:id/update_inventory
  def update_inventory
    method = params[:method]
    item = Item.find_by_name(params[:item_name])
    user_items = @inventory.items.to_a

    unless @user.infection?
      if method === 'add'
        @inventory.items.push(item)
      elsif method === 'remove'
        if user_items.include?(item)
          user_items.delete_at(user_items.index(item))
          @inventory.update!(items: user_items)
        else
          render :json => {:message => "This user doesn't have any #{item.name} in inventory to delete."}
          return
        end
      else
        render :json => {:message => "Unexpected method param for this request. You can try 'add' or 'remove' methods."}
        return
      end
    else
      render :json => {:message => "Infected users cannot update inventory."}
      return
    end
    
    render json: @inventory.items.sort_by(&:id)
    
  end

  # PATCH/PUT /api/v1/users/perform_barter
  def perform_barter
    #first_user
    user_1 = User.find(params[:first_user][:id])
    items_1 = params[:first_user][:items]
    inventory_1 = user_1.inventory.items.to_a
    #second_user
    user_2 = User.find(params[:second_user][:id])
    items_2 = params[:second_user][:items]
    inventory_2 = user_2.inventory.items.to_a

    unless user_1.infection? || user_2.infection?
      
      if validate_user_items(user_1, items_1) && validate_user_items(user_2, items_2) && validate_barter(items_1, items_2)

        items_1.each do |item| 
          item[:amount].times {            
            inventory_1.delete_at(inventory_1.index(Item.find_by_name(item[:name])))
            user_1.inventory.update!(items: inventory_1)
            inventory_2 << Item.find_by_name(item[:name])
          }
        end

        items_2.each do |item| 
          item[:amount].times {
            inventory_2.delete_at(inventory_2.index(Item.find_by_name(item[:name])))
            user_2.inventory.update!(items: inventory_2)
            inventory_1 << Item.find_by_name(item[:name])
          }
        end

        render :json => {:message => "Successful barter!"}
        
      else
        render :json => {:message => "Items doesn't match the inventory or total points per user is different"}
      end
    else
      render :json => {:message => "Infected users cannot trade."}
    end
  end
  
  # PATCH/PUT /api/v1/users/report_infection
  def warn_infection
    author = params[:author_id]
    accused = User.find(params[:accused_user_id])
    infection_control = InfectionControl.find_or_create_by(user: accused)
    
    unless accused.infection?
      unless infection_control.authors.include?(author)
        
        infection_control.authors << author
        infection_control.save!
        
        if infection_control.authors.count == 3
          accused.update!(infection: true)
        end

        render :json => {:message => "Record created successfully!"}

      else
        render :json => {:message => "You already recorded this information earlier."}
      end
    else
      render :json => {:message => "This user is already registered as infected in the system."}
    end
  end

  private

  def validate_user_items(user, items)
    items.each do |item|  
      return false if user.inventory.items.to_a.count(Item.find_by_name(item[:name])) < item[:amount]
    end
  end

  def validate_barter(items_1, items_2)
    sum_1 = 0
    sum_2 = 0
    
    items_1.each do |item| 
      sum_1 += Item.find_by_name(item[:name]).value * item[:amount]
    end

    items_2.each do |item| 
      sum_2 += Item.find_by_name(item[:name]).value * item[:amount]
    end
    
    return sum_1 == sum_2
  end

  def set_user
    @user = User.find(params[:id])
  end

  def set_inventory
    @inventory = Inventory.find_by(user_id: @user.id)
  end

  def user_params
    params.require(:user).permit(:name, :age, :gender, :infection, :last_location)
  end

end
