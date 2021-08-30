FactoryBot.define do
  factory :cook_book do
    user
    title { "Title" }
    visibility { rand(0..2) }
    favourite { false }
  end
end
