FactoryBot.define do
  factory :comment do
    body { Faker::Quote.yoda }
  end
end
