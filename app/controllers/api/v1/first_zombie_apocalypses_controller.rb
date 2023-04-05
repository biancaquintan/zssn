class Api::V1::FirstZombieApocalypsesController < ApplicationController
  before_action :set_user, :set_inventory, only: [:update_location, :update_inventory, :report_infection]

  # POST /api/v1/users/register
  def register_user
    @user = User.new(user_params)

    if @user.save
      render json: @user, status: :created
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
    
    render json: @inventory.items.sort_by(&:id)
    
  end

  private

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
