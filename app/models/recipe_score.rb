class RecipeScore < ApplicationRecord
  enum score: { bad: 1,
                poor: 2,
                average: 3,
                good: 4,
                excellent: 5
              } 
  
  validates :user_id, presence: true
  validates :recipe_id, presence: true
  validates :score, presence: true

  belongs_to :user
  belongs_to :recipe

end
