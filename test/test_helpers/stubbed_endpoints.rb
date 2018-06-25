# frozen_string_literal: true

module StubbedEndpoints
  JOKES = [
    {
      id: 'xkGB5oWSKmb',
      joke: 'Did you hear about the new restaurant on the moon? The food '\
              "is great, but there's just no atmosphere.",
      status: 200
    },
    {
      id: 'UKuXvzAlOuc',
      joke: "I was going to learn how to juggle, but I didn't "\
              'have the balls.',
      status: 200
    },
    {
      id: 'vXgNZ0wcxAd',
      joke: "I'm on a whiskey diet. I've lost three days already.",
      status: 200
    }
  ].freeze

  def stub_joke_api(return_joke_index: nil)
    response = JOKES[return_joke_index].to_json if return_joke_index.is_a?(Integer)
    stub_request(:get, 'https://icanhazdadjoke.com/')
      .with(
        headers: {
          'Accept' => 'application/json',
          'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
          'Host' => 'icanhazdadjoke.com',
          'User-Agent' => 'Daily Dad Joke (https://github.com/sdfreund10/daily_dad_joke)'
        }
      )
      .to_return do
        {
          status: 200, headers: {},
          body: response || random_joke
        }
      end
  end

  def random_joke
    JOKES.sample.to_json
  end
end
