class CookBook < ApplicationRecord
  enum visibility: {public: 0, private: 1, followers: 2}, _prefix: true

  validates_presence_of :title
  validates_inclusion_of :visibility, in: visibilities
  validates_inclusion_of :favourite, in: [true, false]

  belongs_to :user
  has_and_belongs_to_many :recipes
end
