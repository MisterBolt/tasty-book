class Section < ApplicationRecord
  validates :title, presence: true
  validates :body, presence: true

  belongs_to :recipe
end
