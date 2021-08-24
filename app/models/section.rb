class Section < ApplicationRecord
    validates :title, presence: false
    validates :body, presence: false
    
    belongs_to :recipe
end
