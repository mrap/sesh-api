class Api::V1::TokensController < ApplicationController

  version 1

  def create
    @login    = new_token_params
    @email    = @login['email']
    @password = @login['password']

    # Check for all request requirements
    if request.format != :json && @email.nil? && @password.nil?
      error! :bad_request
      return
    end

    @user = User.where(email: @email.downcase).first

    # Check if User Exists
    if @user.nil?
      logger.info("User #{@email} failed signin, user cannot be found")
      error! :unauthenticated
      return
    end

    if @user.valid_password?(@password)
      @user.ensure_authentication_token!
      expose  status: :success,
              auth_token: @user.authentication_token
    else
      logger.info("User #{@email} failed signin, password \"#{@password}\" is invalid")
      error! :unauthenticated
    end
  end

  def destroy
    if @user = User.find(authentication_token: params[:id])
      @user.reset_authentication_token!
      expose  status: :success,
              auth_token: params[:id]
    else
      logger.info('Token not found.')
      error! :bad_request
    end
  end

  private

    def new_token_params
      params.required(:login).permit(:email, :password)
    end


end
