class ErrorController < ApplicationController
  def index
    raise "Error triggered by ErrorController#index"
  end
end
