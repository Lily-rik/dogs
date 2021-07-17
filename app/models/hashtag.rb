class Hashtag < ApplicationRecord
  validates :hashname, presence: true, length: { maximum: 15 }

  has_many :post_hashtags, dependent: :destroy
  has_many :posts, through: :post_hashtags

end
