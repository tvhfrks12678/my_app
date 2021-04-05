class ApplicationController < ActionController::Base
  def hello
    word = 'hello'

    render json: word
  end
end
