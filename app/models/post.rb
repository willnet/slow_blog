class Post < ApplicationRecord
  belongs_to :user
  has_many :comments, dependent: :destroy

  def created_by?(user)
    self.user == user
  end
end
