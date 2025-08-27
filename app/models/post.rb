class Post < ApplicationRecord
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :taggings, dependent: :destroy
  has_many :tags, through: :taggings

  validates :title, presence: true
  validates :body, presence: true

  enum :status, { published: 0, unpublished: 1 }

  attr_accessor :tag_names

  def created_by?(user)
    self.user == user
  end

  def tag_names=(names)
    @tag_names = names
    if names.present?
      tag_list = names.split(",").map(&:strip).reject(&:blank?)
      self.tags = tag_list.map do |name|
        Tag.find_or_create_by(name: name)
      end
    else
      self.tags = []
    end
  end
end
