class Api::V1::UsersController < ApplicationController

  version 1

  # GET /users
  # GET /users.json
  def index
    @users = User.all

    collection json: @users
  end

  # GET /users/1
  # GET /users/1.json
  def show
    @user = User.find(params[:id])

    if @user
      expose @user
    else
      error! :not_found
    end
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(params[:user])

    if @user.save
      expose json: @user, status: :created, location: @user
    else
      expose json: @user.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    @user = User.find(params[:id])

    if @user.update(params[:user])
      head :no_content
    else
      expose json: @user.errors, status: :unprocessable_entity
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user = User.find(params[:id])
    @user.destroy

    head :no_content
  end
end
