FactoryBot.define do
  factory :article do
    title { Faker::Lorem.sentence }
    body { Faker::Lorem.paragraph }
    visibility { Faker::Boolean.boolean }
    slug { Faker::Internet.slug }

    association :user

    trait :with_user do
      association :user, factory: :user
    end
  end
end
