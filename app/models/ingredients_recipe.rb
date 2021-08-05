class IngredientsRecipe < ApplicationRecord
    validates :quantity, presence: true
    validates :unit, presence: true
    enum unit: {gram: 0, mililiter: 1, teaspoon: 2, piece: 3}, _suffix: true

    belongs_to :recipe
    belongs_to :ingredient
end