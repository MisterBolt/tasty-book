class IngredientsRecipe < ApplicationRecord
  validates :quantity, presence: true
  validates :unit, presence: true
  enum unit: {ml: 0, glass: 1, tablespoon: 2, teaspoon: 3, gram: 4}, _suffix: true

  belongs_to :recipe
  belongs_to :ingredient

  def ingredient_name
    ingredient&.name
  end

  def ingredient_name=(name)
    self.ingredient = Ingredient.find_or_create_by(name: name)
  end

  def unit=(unit)
    super(unit.present? ? unit.to_i : unit)
  end
end
