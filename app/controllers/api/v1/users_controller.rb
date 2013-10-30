class Api::V1::UsersController < ApplicationController

  before_action :get_user, only: [:show, :update, :destroy]

  # GET /users
  def index
    @users = User.all
  end

  # GET /users/1
  def show
    authenticate_user!
    # implicitly calls get_user
  end

  # POST /users
  def create
    @user = User.new(user_params)

    if @user.save
      render status: :created
    else
      render nothing: true,  status: 422 # Unprocessable Entity
    end
  end

  # PATCH/PUT /users/1
  def update
    if @user.update(params[:user])
      head :no_content
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # DELETE /users/1
  def destroy
    @user.destroy
    head :no_content
  end

  private

    def get_user
      unless @user = User.find(params[:id])
        render nothing: true, status: 404
        return false
      end
    end

    def authenticate_user!
      @user_authenticated = @user.authentication_token == params[:auth_token]
    end

    def user_params
      params.required(:user).permit(:username, :email, :password)
    end

end
