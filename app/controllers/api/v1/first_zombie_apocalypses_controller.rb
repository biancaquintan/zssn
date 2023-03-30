class Api::V1::FirstZombieApocalypsesController < ApplicationController
  before_action :set_user, only: [:update_location]

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

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :age, :gender, :infection, :last_location)
  end

end
