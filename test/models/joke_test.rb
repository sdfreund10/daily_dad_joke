require 'test_helper'

class JokeTest < ActiveSupport::TestCase
  test "upsert from api creates new records" do
    params = { "id" => "asdfg", "joke" => "Test Joke", "status" => "200" }
    initial = Joke.count
    assert_changes ->{ Joke.count }, 1 do
      Joke.upsert_from_api(params)
    end
  end

  test "upsert from api finds existing records" do
    params = { "id" => "asdfg", "joke" => "Test Joke", "status" => "200" }
    Joke.create!(api_id: params["id"], joke: params["joke"])
    assert_no_changes ->{ Joke.count } do
      Joke.upsert_from_api(params)
    end
  end

  test "upsert from api returns joke instance" do
    params = { "id" => "asdfg", "joke" => "Test Joke", "status" => "200" }
    # create new record
    result = Joke.upsert_from_api(params)
    assert_instance_of(Joke, result)

    # upssert record
    params["joke"] = "New joke"
    result = Joke.upsert_from_api(params)
    assert_instance_of(Joke, result)
  end
end
