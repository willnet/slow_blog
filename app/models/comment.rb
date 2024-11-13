class Comment < ApplicationRecord
  belongs_to :post
  belongs_to :user

  def created_by?(user)
    self.user == user
  end
end
