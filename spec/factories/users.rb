FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    password { 'password' }

    trait :confirmed do
      confirmed_at { Time.current }
    end
  end
end
