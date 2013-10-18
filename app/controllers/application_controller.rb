class ApplicationController < RocketPants::Base

  # Devise requires MimeResponds and StrongParameters modules
  # Source: http://www.emilsoman.com/blog/2013/05/18/building-a-tested/
  include ActionController::MimeResponds
  include ActionController::StrongParameters

  map_error! Mongoid::Errors::Validations do |exception|
    RocketPants::InvalidResource.new exception.record.errors
  end

end
