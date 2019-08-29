class User < ApplicationRecord
  include UserConcern

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [:google_oauth2]

  has_many :results, dependent: :destroy

  STANDINGS_COLUMNS = %w[id team name points current_streak current_pick].freeze

  scope :standings, lambda {
    standings_query(STANDINGS_COLUMNS)
  }

  scope :standings_without_current_pick, lambda {
    standings_query(STANDINGS_COLUMNS - ['current_pick'])
  }

  scope :get_rank, lambda { |user|
    user_id = user.id
    # Could write a more verbose query to reduce filtering in memory
    # but unconcerned for now due to on the order of 50 users
    standings.select { |u| u.id == user_id }&.first&.rank
  }

  def self.from_omniauth(access_token)
    data = access_token.info
    user = User.find_by(email: data['email']) ||
           User.create(
             name: data['name'],
             email: data['email'],
             password: Devise.friendly_token[0, 20]
           )
    user
  end
end
