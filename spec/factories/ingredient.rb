FactoryBot.define do
  factory :ingredient do
    sequence(:name) { |n| "ingredient##{n}" }
  end
end
