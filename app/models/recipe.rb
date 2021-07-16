class Recipe < ApplicationRecord
  has_many :recipe_scores,
           dependent: :destroy

  has_many :scorers,
           through: :recipe_scores,
           source: :user
end
