FactoryBot.define do
  factory :recipe_score do
    user_id { create(:user).id }
    recipe_id { create(:recipe).id }
    score { rand(1..5) }
  end
end
