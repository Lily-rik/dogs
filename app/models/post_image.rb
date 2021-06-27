class PostImage < ApplicationRecord
  
  #validates :image, presence: true
  
  belongs_to :post
  attachment :image


end
