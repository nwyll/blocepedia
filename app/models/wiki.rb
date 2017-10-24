class Wiki < ApplicationRecord
  belongs_to :user
  default_scope { order("title ASC") }
  
  validates :title, length: {minimum: 5}, presence: true
  validates :body, length: {minimum: 10}, presence: true
  validates :user, presence: true
end
