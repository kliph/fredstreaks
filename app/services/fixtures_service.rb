# Service exposing the Soccer Fixtures from the API
module FixturesService
  URL = 'http://api.football-data.org/v2/competitions/2021/matches'.freeze
  FINISHED_STATUSES = %w[FINISHED CANCELED POSTPONED].freeze

  def self.fetch_fixtures(gameweek)
    response = Faraday.get(
      URL,
      { matchday: gameweek },
      'X-Response-Control' => 'minified', 'X-Auth-Token' => ENV.fetch('FOOTBALL_DATA_AUTH_TOKEN')
    )
    transformed_response = JSON.parse(response.body).deep_transform_keys { |k| k.to_s.underscore }
    transformed_response['matches']
  end

  def self.all_finished?(matches)
    statuses = matches.pluck('status')
    statuses.present? && statuses.all? do |status|
      matches_at_least_one(status, FINISHED_STATUSES)
    end
  end

  def self.save_fixture_if_updated!(matches)
    current_fixture = Fixture.find_or_initialize_by(gameweek: Gameweek.last)
    current_fixture.update(matches: matches) if matches != current_fixture.matches
  end

  def self.score_finished_gameweek!(matches:, gameweek:, user:, date:)
    winners = matches_to_winners_set(matches)
    result_params = {
      user: user,
      pick: user.current_pick,
      gameweek: gameweek,
      date: date
    }
    points_to_award = 0
    updated_streak = 0
    if winners.include?(user.current_pick)
      incremented_streak = user.current_streak + 1
      points_to_award = incremented_streak
      updated_streak = incremented_streak
    end
    result_params[:points] = points_to_award
    Result.create result_params
    user.points += points_to_award
    user.current_pick = nil
    user.current_streak = updated_streak
    user.save
  end

  def self.increment_gameweek!(gameweek)
    Gameweek.create(week: gameweek.week + 1)
  end

  def self.score_all_picks_and_increment_gameweek!(matches:, gameweek:)
    User.all.each do |user|
      FixturesService.score_finished_gameweek!(matches: matches, gameweek: gameweek, user: user, date: Date.new)
    end
    FixturesService.increment_gameweek!(gameweek)
  end

  private_class_method def self.matches_at_least_one(status, comparison_statuses)
    comparison_statuses.any? { |comparison_status| status == comparison_status }
  end

  private_class_method def self.get_winner_or_nil(match)
    winner = match.fetch('score').fetch('winner').downcase
    winning_team = winner != 'draw' ? match.fetch(winner).fetch('name') : nil
    winning_team
  end

  private_class_method def self.matches_to_winners_set(matches)
    matches.map do |match|
      get_winner_or_nil(match)
    end.compact
  end
end
