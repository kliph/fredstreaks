class Gameweek < ApplicationRecord
  has_many :fixtures, dependent: :destroy
end
