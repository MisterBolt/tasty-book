class User < ApplicationRecord
  has_many :comments
  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :validatable

  validates :username, uniqueness: true, presence: true

  has_many :recipe_scores,
    dependent: :destroy

  has_many :scored_recipes,
    through: :recipe_scores,
    source: :recipe

  has_many :recipes     
end
