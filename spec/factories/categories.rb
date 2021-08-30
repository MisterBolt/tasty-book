FactoryBot.define do
  factory :category do
    sequence(:name) { |n| "Dinner##{n}" }

    trait :seed do
      name { Faker::Food.unique.ethnic_category }
    end
  end
end
