FactoryBot.define do
  factory :result do
    user
    gameweek
    points { 1 }
    pick { 'Tranmere Rovers FC' }
  end
end
