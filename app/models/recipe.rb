# frozen_string_literal: true
class Recipe < ApplicationRecord
    validates :title, presence: true
end
