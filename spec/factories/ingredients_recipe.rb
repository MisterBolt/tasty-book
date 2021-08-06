FactoryBot.define do
  factory :ingredients_recipe do
    recipe
    ingredient
    quantity { rand(1..100) }
    unit { rand(0..3) }
  end
end
