class UsersController < ApplicationController
    before_action :find_user, only: %i[update show destroy]
    before_action :authenticate!, except: %i[index create]
  
    def index
      users = User.all
      render json: users, status: :ok
    end
  
    def create
      user = User.new(user_params)
      if user.save
        render json: user, status: :created
      else
        render json: user.errors, status: :unprocessable_entity
      end
    end
  
    def update
      @user.write_attributes(user_params)
      if @user.save
        render json: @user
      else
        render json: @user.errors, status: :unprocessable_entity
      end
    end
  
    def show
      render json: @user
    end
  
    def destroy
      @user.destroy!
      render :no_content
    end
  
    private
  
    def user_params
      params.permit(:password, :email)
    end
  
    def find_user
      @user = User.find(params[:id])
    end
end