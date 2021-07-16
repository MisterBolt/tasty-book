class User < ApplicationRecord
  has_many :comments
  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :validatable

  validates :username, uniqueness: true, presence: true

  has_many :recipe_scores,
    dependent: :destroy

  has_many :scored_recipes,
<<<<<<< HEAD
    through: :recipe_scores,
    source: :recipe
=======
           through: :recipe_scores,
           source: :recipe

  has_many :recipes     
>>>>>>> 42e70f9... Enabled author to delete his own recipe
end
