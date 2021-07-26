FactoryBot.define do
  factory :cook_book do
    user
    title { "Title" }
    visibility { :public }
  end
end
