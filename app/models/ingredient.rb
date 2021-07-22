class Ingredient < ApplicationRecord
    validates :name, presence: true, uniqueness: true, length: {maximum: 30}

    has_and_belongs_to_many :recipes
end
