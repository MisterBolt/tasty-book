require 'faker'
require 'factory_bot_rails'

puts "Seeding users"
users = FactoryBot.create_list(:user, 20)

puts "Seeding ingredients"
ingredients = FactoryBot.create_list(:ingredient, 10)


puts "Seeding recipes"
puts "Seeding cookbooks"
puts "Adding followings"
users.each do |user|
  rand(0..4).times do
    FactoryBot.create(:recipe, user_id: user.id)
  end
  rand(0..3).times do
    FactoryBot.create(:cook_book, user_id: user.id)
  end
  rand(0..4).times do
    following = users.sample
    user.followings << following if !user.followings.includes(following)
  end
end  

recipes = Recipe.all

puts "Choosing recipe ingredients"
recipes.each do |recipe|
  rand(3..9).times do
    FactoryBot.create(:ingredients_recipe, recipe_id: recipe.id, ingredient: ingredients.sample)
  end
end

puts "Generating comments"
puts "Scoring recipes"
users.each do |user|
  recipes.each do |recipe|
    rand(0..3).times do
      FactoryBot.create(:comment, user_id: user.id, recipe_id: recipe.id)
    end
    rand(0..1).times do
      FactoryBot.create(:recipe_score, user_id: user.id, recipe_id: recipe.id)
    end
  end
end

puts "Adding recipes to cookbooks"
cook_books = CookBook.all
  cook_books.each do |book|
    rand(5..20).times do
      recipe = recipes.sample
      book.recipes << recipe
    end
  end

puts "DB seeded!"
