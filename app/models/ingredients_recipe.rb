class IngredientsRecipe < ApplicationRecord
  validates :quantity, presence: true
  validates :unit, presence: true
  enum unit: {ml: 0, glass: 1, tablespoon: 2, teaspoon: 3, gram: 4}, _suffix: true

  belongs_to :recipe
  belongs_to :ingredient
end
