class Api::V1::FirstZombieApocalypsesController < ApplicationController

  # POST /api/v1/users/register
  def register_user
    @user = User.new(user_params)

    if @user.save
      render json: @user, status: :created
    else
      render json: @user.errors, status: :unprocessable_entity
    end

  end
  
  private

  def user_params
    params.require(:user).permit(:name, :age, :gender, :infection, :last_location)
  end

end
