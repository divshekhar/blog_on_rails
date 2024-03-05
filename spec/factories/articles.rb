FactoryBot.define do
  factory :article do
    title { Faker::Lorem.sentence }
    body { Faker::Lorem.paragraph }
    user_id { 1 }
    visibility { Faker::Boolean.boolean }
    slug { Faker::Internet.slug }

    association :user

    trait :with_user do
      association :user, factory: :user
    end
  end
end
