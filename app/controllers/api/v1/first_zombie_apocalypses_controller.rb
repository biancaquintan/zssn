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
    
    update_method = Inventory.update(@user, @inventory, method, item)

    unless update_method[:error_message].nil?
      render json: update_method
    else
      render json: @inventory.items.sort_by(&:id)
    end
  end

  # PATCH/PUT /api/v1/users/perform_barter
  def perform_barter
    #first_user
    user_1 = User.find(params[:first_user][:id])
    items_1 = params[:first_user][:items]
    inventory_1 = user_1.inventory
    #second_user
    user_2 = User.find(params[:second_user][:id])
    items_2 = params[:second_user][:items]
    inventory_2 = user_2.inventory

    unless user_1.infection? || user_2.infection?
      
      if validate_user_items(user_1, items_1) && validate_user_items(user_2, items_2) && validate_barter(items_1, items_2)

        items_1.each do |item| 
          item[:amount].to_i.times {       
            Inventory.update(user_1, inventory_1, "remove", Item.find_by_name(item[:name]))
            Inventory.update(user_2, inventory_2, "add", Item.find_by_name(item[:name]))
          }
        end

        items_2.each do |item| 
          item[:amount].to_i.times {
            Inventory.update(user_2, inventory_2, "remove", Item.find_by_name(item[:name]))
            Inventory.update(user_1, inventory_1, "add", Item.find_by_name(item[:name]))
          }
        end
        
        render :json => {:message => "Successful barter!"}
      
      else
        
        render :json => {:error_message => "Items doesn't match the inventory or total points per user is different"}
      
      end
    else
      render :json => {:error_message => "Infected users cannot trade."}
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

  # GET /api/v1/users/users_data_report
  def users_data_report
    @reports = {}
    @reports[:infections] = Report.calc_average_infections[:infection]
    @reports[:uninfections] = Report.calc_average_infections[:uninfection]
    # average_items_users are not including infected user data 
    @reports[:average_items_users] = Report.calc_average_items_users
    @reports[:total_lost_by_infected] = Report.calc_total_lost

    render json: @reports, status: :ok
  end

  private

  def validate_user_items(user, items)
    items.each do |item|  
      return false if user.inventory.items.to_a.count(Item.find_by_name(item[:name])) < item[:amount].to_i
    end
  end

  def validate_barter(items_1, items_2)
    sum_1 = 0
    sum_2 = 0
    
    items_1.each do |item| 
      sum_1 += Item.find_by_name(item[:name]).value * item[:amount].to_i
    end

    items_2.each do |item| 
      sum_2 += Item.find_by_name(item[:name]).value * item[:amount].to_i
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
