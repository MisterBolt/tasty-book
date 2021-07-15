class Comment < ApplicationRecord
  belongs_to :recipe
  belongs_to :user
  validates_presence_of :body
end
