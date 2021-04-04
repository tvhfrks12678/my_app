class ApplicationController < ActionController::Base
  def hello
    render json: "hello"
  end
end
