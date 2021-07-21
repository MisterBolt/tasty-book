class Ingredient < ApplicationRecord
    validates :name, presence: true, uniqueness: true, length: {maximum: 30}

    has_many :recipe_ingredients
    has_many :recipes, through: :recipe_ingredients
end
