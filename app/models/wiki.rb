class Wiki < ApplicationRecord
  belongs_to :user
  has_many :collaborators, dependent: :destroy
  has_many :collaborating_users, through: :collaborators, source: :user

  default_scope { order("title ASC") }
  
  before_save { self.private ||= false }
  
  validates :title, length: {minimum: 5}, presence: true
  validates :body, length: {minimum: 10}, presence: true
  validates :user, presence: true
end
