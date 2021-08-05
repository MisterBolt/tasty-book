FactoryBot.define do
  factory :recipe do
    title { Faker::Food.dish }
    preparation_description { Faker::Food.description }
  end
end
