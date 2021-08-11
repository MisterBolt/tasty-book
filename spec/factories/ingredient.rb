FactoryBot.define do
  factory :ingredient do
    name { Faker::Food.unique.ingredient }
  end
end
