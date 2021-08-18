FactoryBot.define do
  factory :category do
    sequence(:name) { |n| "Dinner##{n}" }
  end
end
