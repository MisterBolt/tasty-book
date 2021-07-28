FactoryBot.define do
  factory :recipe do
    title { Faker::Food.dish }
    preperation_description { Faker::Food.description }
  end
end
