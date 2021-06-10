class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  attachment :image

  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :favorites, dependent: :destroy



   has_many :following_relationships, foreign_key: "follower_id", class_name: "Relationship",  dependent: :destroy
   has_many :following, through: :following_relationships
   has_many :follower_relationships, foreign_key: "following_id", class_name: "Relationship", dependent: :destroy
   has_many :followers, through: :follower_relationships


  #フォローしているかを確認するメソッド
  def following?(user)
    following_relationships.find_by(following_id: user.id)
  end

  #フォローするときのメソッド
  def follow(user)
    following_relationships.create!(following_id: user.id)
  end

  #フォローを外すときのメソッド
  def unfollow(user)
    following_relationships.find_by(following_id: user.id).destroy
  end




  # 退会フラグがfalseの時しかログインできないようにする
  def active_for_authentication?
    super && (self.is_deleted == false)
  end

def self.looks(searches, words)
    if searches == "perfect_match"
      @user = User.where("name LIKE ? OR email LIKE ?", "#{words}", "#{words}")
    else
      @user = User.where("name LIKE ? OR email LIKE ?", "%#{words}%", "%#{words}%")
    end
end






end
