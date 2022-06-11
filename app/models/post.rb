class Post
  include Mongoid::Document

  field :title, type: String
  field :body, type: String

  has_many :comments, dependent: :destroy

  validates :title, length: { minimum: 6, maximum: 50 }
  validates :title, presence: true, uniqueness: true
end