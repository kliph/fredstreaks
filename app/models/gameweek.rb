class Gameweek < ApplicationRecord
  has_many :fixtures, dependent: :destroy
  has_many :results, dependent: :destroy
end
