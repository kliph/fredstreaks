FactoryBot.define do
  factory :result do
    user
    gameweek
    points { 1 }
    date { '2019-09-09' }
    pick { 'Tranmere Rovers FC' }
  end
end
