FactoryBot.define do
  factory :recipe do
    transient do
      unique_ingredient { nil }
    end
    user
    title { Faker::Food.dish }
    difficulty { rand(0..2) }
    time_in_minutes_needed { rand(5..60) }
    categories { create_list(:category, rand(1..3)) }
    layout { rand(0..2) }
    status { 1 }

    after(:build) do |recipe, evaluator|
      recipe.ingredients_recipes << build(
        :ingredients_recipe,
        recipe: recipe,
        ingredient: evaluator.unique_ingredient || create(:ingredient)
      )
    end
  end
end
