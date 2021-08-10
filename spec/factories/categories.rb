FactoryBot.define do
  factory :category do
    name { Faker::Verb.unique.base }
  end
end
