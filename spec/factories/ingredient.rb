FactoryBot.define do
  factory :ingredient do
    name { Faker::Verb.base }
  end
end
