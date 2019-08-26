class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [:google_oauth2]

  has_many :results, dependent: :destroy

  scope :standings, lambda {
    find_by_sql('SELECT *, rank() OVER (ORDER BY points DESC) FROM users')
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
