class Post < ApplicationRecord
  belongs_to :user
  has_many :comments

  def created_by?(user)
    self.user == user
  end
end
