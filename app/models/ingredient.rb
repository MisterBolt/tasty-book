class Ingredient < ApplicationRecord
  validates :name, presence: true, uniqueness: true

  has_many :ingredients_recipes
  has_many :recipes, through: :ingredients_recipes
end
