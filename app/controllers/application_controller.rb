class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  private

  def get_dad_joke
    @example = HTTParty.get('http://icanhazdadjoke.com', headers: {"Accept" => "application/json" }).parsed_response
  end
end
