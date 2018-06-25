# frozeb_string_literal: true

require 'net/http'
require 'json'

class MessageSender
  def initialize(user_ids)
    # ids of users who are expecting a message
    @user_ids = user_ids
  end

  def call
    attempts = 0
    loop do
      users = send_messages(set_joke)
      @user_ids -= users.map(&:id)
      break if @user_ids.empty? || attempts > 500
      attempts += 1
      sleep 0.1 # rate limit
    end
  end

  private

  def send_messages(joke)
    users_to_exclude = UserJokeHistory.where(joke: joke).pluck(:user_id)
    User.where(id: @user_ids - users_to_exclude).each do |user|
      twilio_client.messages.create(
        from: ENV["PHONE_NUMBER"],
        to: user.formatted_phone_number,
        body: joke.joke
      )
      UserJokeHistory.create!(user: user, joke: joke)
    end
  end

  def set_joke
    @joke = get_joke.yield_self do |joke|
      Joke.upsert_from_api(joke)
    end
  end

  def get_joke
    uri = URI.parse("https://icanhazdadjoke.com/")
    request = Net::HTTP::Get.new(uri)
    request["Accept"] = "application/json"
    request["User-Agent"] = "Daily Dad Joke (https://github.com/sdfreund10/daily_dad_joke)"

    response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
      http.request(request)
    end
    JSON.parse(response.body)
  end

  def twilio_client
    @twilio_client ||= Twilio::REST::Client.new(
      ENV["ACCOUNT_SID"], ENV["AUTH_TOKEN"]
    )
  end
end
