class Comment < ApplicationRecord
  belongs_to :post
  belongs_to :user

  validates :body, presence: true

  def created_by?(user)
    self.user == user
  end
end
