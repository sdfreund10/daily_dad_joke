require 'test_helper'

class MessageSenderTest < ActiveSupport::TestCase
  include StubbedEndpoints
  setup do
    TwilioClientStub.messages.clear
  end

  test 'message sender sends json request to icanhazdadjoke.com' do
    stub_joke_api
    MessageSender.new([]).call
    assert_requested(
      :get, 'https://icanhazdadjoke.com/',
      headers: {
        'Accept' => 'application/json',
        'User-Agent' => 'Daily Dad Joke (https://github.com/sdfreund10/daily_dad_joke)'
      }, times: 1
    )
  end

  test 'saves new jokes before sending' do
    stub_joke_api
    assert_changes -> { Joke.count }, 1 do
      MessageSender.new([]).call
    end
  end

  test 'updates jokes at time of message' do
    joke = Joke.create!(api_id: JOKES[0][:id], joke: '')
    stub_joke_api(return_joke_index: 0)
    assert_no_changes -> { Joke.count } do
      MessageSender.new([]).call
    end
    joke.reload
    assert_equal(joke.joke, JOKES[0][:joke])
  end

  test 'requests new joke if user has recieved joke already' do
    user = User.create(phone_number: '1234567890', name: 'Test')
    joke = Joke.create!(api_id: JOKES[0][:id], joke: JOKES[0][:joke])
    UserJokeHistory.create!(joke: joke, user: user)
    stub_joke_api
    assert_changes -> { Joke.count }, 1 do
      MessageSender.new([user.id]).call
    end
    assert_equal(user.user_joke_histories.count, 2)
    assert_equal(TwilioClientStub.messages.length, 1)
    message = TwilioClientStub.messages.first
    assert_equal(user.formatted_phone_number, message.to)
    assert_equal(ENV['PHONE_NUMBER'], message.from)
    assert_not_equal(joke.joke, message.body)
  end

  test 'send message to users who have not recieved joke' do
    user = User.create(phone_number: '1234567890', name: 'Test')
    stub_joke_api(return_joke_index: 0)
    MessageSender.new([user.id]).call
    assert_equal(TwilioClientStub.messages.length, 1)
    message = TwilioClientStub.messages.first
    assert_equal(user.formatted_phone_number, message.to)
    assert_equal(ENV['PHONE_NUMBER'], message.from)
    assert_equal(JOKES[0][:joke], message.body)
  end

  test 'send same joke to multiple users if new joke' do
    users = [
      User.create!(phone_number: '1234567890', name: 'Test'),
      User.create!(phone_number: '0123456789', name: 'Test')
    ]
    stub_joke_api
    assert_changes -> { UserJokeHistory.count }, 2 do
      MessageSender.new(users.map(&:id)).call
    end
    assert_equal(UserJokeHistory.count, 2)
    messages = TwilioClientStub.messages
    assert_equal(Joke.count, 1)
    assert_equal(
      messages.map(&:body).sort, [Joke.first.joke, Joke.first.joke].sort
    )
  end

  test 'send different jokes to multiple users' do
    users = [
      User.create!(phone_number: '1234567890', name: 'Test'),
      User.create!(phone_number: '0123456789', name: 'Test')
    ]
    JOKES[0..1].each do |joke_params|
      joke = Joke.create!(api_id: joke_params[:id], joke: joke_params[:joke])
      UserJokeHistory.create!(user: users.first, joke: joke)
    end
    stub_joke_api
    assert_changes -> { UserJokeHistory.count }, 2 do
      MessageSender.new(users.map(&:id)).call
    end
    assert_equal(UserJokeHistory.count, 4)
    messages = TwilioClientStub.messages
    assert_equal(messages.length, 2)
    assert_not_equal(messages.first['body'], messages.last['body'])
  end

  test 'saves joke history' do
    user = User.create(phone_number: '1234567890', name: 'Test')
    stub_joke_api
    assert_changes -> { UserJokeHistory.count }, 1 do
      MessageSender.new([user.id]).call
    end
  end
end
