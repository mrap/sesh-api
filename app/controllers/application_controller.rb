class ApplicationController < ActionController::API

  # Devise requires MimeResponds and StrongParameters modules
  # Source: http://www.emilsoman.com/blog/2013/05/18/building-a-tested/
  include ActionController::MimeResponds
  include ActionController::StrongParameters

end
