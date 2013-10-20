class Api::V1::TokensController < ApplicationController

  version 1

  skip_before_filter :verify_authenticity_token

  def create
    email = params[:email]
    password = params[:password]

    unless request.format == :json
      expose  status: 406,
              message: 'The request must be json'
      return
    end

    unless email || password
      expose  status: 400,
              message: "The request must contain a user's email and password"
      return
    end

    @user = User.where(email: email.downcase).first
    unless @user
      logger.info("User #{email} failed signin, user cannot be found")
      expose  status: 401,
              message: 'Invalid email or password'
      return
    end

    # http://rdoc.info/github/plataformatec/devise/master/Devise/Models/TokenAuthenticatable
    @user.ensure_authentication_token!

    unless @user.valid_password?(password)
      logger.info("User #{email} failed signin, password \"#{password}\" is invalid")
      expose  status: 401,
              message: "Invalid email or password."
    else
      expose  status: 200,
              token: @user.authentication_token
    end
  end

  def destroy
    @user = User.find(authentication_token: params[:id])
    unless @user
      logger.info('Token not found.')
      expose  status: 404,
              message: 'Invalid token.'
    else
      @user.reset_authentication_token!
      expose  status: 200,
              token: params[:id]
    end
  end
end
