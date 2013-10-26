class Api::V1::UsersController < ApplicationController

  version 1

  before_action :get_user, only: [:show, :update, :destroy]

  # GET /users
  # GET /users.json
  def index
    @users = User.all

    collection json: @users
  end

  # GET /users/1
  # GET /users/1.json
  def show
    if correct_user?
      expose  info: { username: @user.username },
              seshes: @user.sesh_ids
    else
      expose  info: { username: @user.username },
              seshes: @user.public_sesh_ids
    end
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)

    if @user.save
      expose  info: { username: @user.username },
              authentication_token: @user.authentication_token
    else
      error! :invalid_resource, @user.errors
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    if @user.update(params[:user])
      head :no_content
    else
      expose json: @user.errors, status: :unprocessable_entity
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    head :no_content
  end

  private

    def get_user
      if @user = User.find(params[:id])
        @user
      else
        error! :not_found
      end
    end

    def user_params
      params.required(:user).permit(:username, :email, :password)
    end

    def correct_user?
      @user.authentication_token == params[:authentication_token]
    end

end
