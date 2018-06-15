class HomeController < ApplicationController
  def index
    @dad_joke = {} # get_dad_joke
    @new_user = User.new
  end
end
