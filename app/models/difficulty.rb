class Difficulty < ApplicationRecord
    NAMES = ["EASY", "MEDIUM", "HARD"].freeze

    validates :name, presence: true, uniqueness: true, inclusion: {in: NAMES}

    has_many :recipes
end
