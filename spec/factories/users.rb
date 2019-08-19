FactoryBot.define do
  factory :user do
    sequence :name do |n|
      "User #{n}"
    end
    sequence :email do |n|
      "user#{n}@example.com"
    end
    sequence :team do |n|
      "Team Name #{n}"
    end
    password { 'password' }
  end
end