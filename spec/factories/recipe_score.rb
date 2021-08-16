FactoryBot.define do
  factory :recipe_score do
    user
    recipe
    score { rand(1...5) }
  end
end
