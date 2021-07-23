class Comment < ApplicationRecord
  include ActionView::RecordIdentifier

  belongs_to :recipe
  belongs_to :user
  validates_presence_of :body
  after_create_commit -> { broadcast_prepend_to [recipe, :comments], target: "#{dom_id(recipe)}_comments" }
  
end
