# frozen_string_literal: true

class Recipe < ApplicationRecord
  validates :title, presence: true

  has_many :recipe_scores,
    dependent: :destroy

  has_many :scorers,
<<<<<<< HEAD
    through: :recipe_scores,
    source: :user
  has_many :comments, dependent: :destroy
=======
           through: :recipe_scores,
           source: :user
  
  belongs_to :user
>>>>>>> 42e70f9... Enabled author to delete his own recipe
end
