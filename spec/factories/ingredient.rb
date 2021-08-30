FactoryBot.define do
  factory :ingredient do
    sequence(:name) { |n| "ingredient##{n}" }

    trait :seed do
      name { Faker::Food.unique.ingredient }
    end
  end
end
