# Service exposing the Soccer Fixtures from the API
module FixturesService
  URL = 'http://api.football-data.org/v2/competitions/2021/matches'.freeze

  def self.fetch_fixtures
    response = Faraday.get(URL, { matchday: Gameweek.last.id }, 'X-Response-Control' => 'minified', 'X-Auth-Token' => ENV.fetch('FOOTBALL_DATA_AUTH_TOKEN'))
    transformed_response = JSON.parse(response.body).deep_transform_keys { |k| k.to_s.underscore.to_sym }
    transformed_response[:matches]
  end
end
