class Api::V1::TokensController < ApplicationController

  def create
    @login    = new_token_params
    @email    = @login['email']
    @password = @login['password']

    # Check for all request requirements
    if request.format != :json && @email.nil? && @password.nil?
      render nothing: true, status: :bad_request
      return
    end

    @user = User.where(email: @email.downcase).first

    # Check if User Exists
    if @user.nil?
      logger.info("User #{@email} failed signin, user cannot be found")
      render nothing: true, status: :unauthorized
      return
    end

    if @user.valid_password?(@password)
      @user.ensure_authentication_token!
      render status: :created
    else
      logger.info("User #{@email} failed signin, password \"#{@password}\" is invalid")
      render nothing: true, status: :unauthorized
    end
  end

  def destroy
    if @user = User.find_by(authentication_token: params[:id])
      @user.reset_authentication_token!
      render nothing: true, status: :ok
    else
      logger.info('Token not found.')
      render nothing: true, status: :bad_request
    end
  end

  private

    def new_token_params
      params.required(:login).permit(:email, :password)
    end

    def user_token_params
      params.required(:a)
    end


end
