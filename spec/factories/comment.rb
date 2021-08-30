FactoryBot.define do
  factory :comment do
    user
    recipe
    body { Faker::Quote.yoda }
    status { :approved }
  end
end
