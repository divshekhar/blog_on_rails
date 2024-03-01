FactoryBot.define do
  factory :article do
    title { Faker::Lorem.sentence }
    body { Faker::Lorem.paragraph }
    author { Faker::Name.name }
    visibility { Faker::Boolean.boolean }
    slug { Faker::Internet.slug }
  end
end
