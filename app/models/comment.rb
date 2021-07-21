class Comment < ApplicationRecord
  belongs_to :recipe
  belongs_to :user, optional: true
  validates_presence_of :body
end
