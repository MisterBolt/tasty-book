FactoryBot.define do
  factory :section do
    title { Faker::Food.dish }
    body { Faker::Food.description }
  end
end
