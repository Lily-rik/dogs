class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
         
         
  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  
  
  has_many :active_relationships, class_name: "Relationship"
  has_many :passive_relationships, class_name: "Relationship"
  

  attachment :image

  # 退会フラグがfalseの時しかログインできないようにする
  def active_for_authentication?
    super && (self.is_deleted == false)
  end





end
