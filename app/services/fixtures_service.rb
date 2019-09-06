# Service exposing the Soccer Fixtures from the API
module FixturesService
  URL = 'http://api.football-data.org/v2/competitions/2021/matches'.freeze
  FINISHED_STATUSES = %w[FINISHED CANCELED POSTPONED].freeze

  def self.fetch_fixtures(gameweek_id)
    response = Faraday.get(
      URL,
      { matchday: gameweek_id },
      'X-Response-Control' => 'minified', 'X-Auth-Token' => ENV.fetch('FOOTBALL_DATA_AUTH_TOKEN')
    )
    transformed_response = JSON.parse(response.body).deep_transform_keys { |k| k.to_s.underscore }
    transformed_response['matches']
  end

  def self.all_finished?(matches)
    statuses = matches.pluck('status')
    statuses.all? do |status|
      matches_at_least_one(status, FINISHED_STATUSES)
    end
  end

  def self.save_fixture_if_updated!(matches)
    current_fixture = Fixture.find_or_initialize_by(gameweek: Gameweek.last)
    current_fixture.update(matches: matches) if matches != current_fixture.matches
  end

  private_class_method def self.matches_at_least_one(status, comparison_statuses)
    comparison_statuses.any? { |comparison_status| status == comparison_status }
  end
end
