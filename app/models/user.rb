class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
         
         
  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  
  # フォロー・フォロワー
  
  ## フォローする側のユーザーから見て、中間テーブルを介してフォローされるユーザーを集めてくる。そのためFKはfollowing_idとなる
  has_many :active_relationships, class_name: "Relationship", foreign_key: :following_id
            ## follower_idをたくさん持っている                 ## FK=親なので、同じfollowing_idが対象となる
            
  ## followings = followerd_idたち。 = active_relationships 親(source)はfollower
  has_many :followings, through: :active_relationships, source: :follower
  
  ## フォローされている側のユーザーから見て、中間テーブルを介してフォローしてくれているユーザーを集めてくる。そのためFKはfollower_idとなる
  has_many :passive_relationships, class_name: "Relationship", foreign_key: :follower_id
            ## following_idをたくさん持っている                 ## FK=親なので、同じfollower_idが対象となる
            
  ## followers = following_idたち。 = passive_relationships 親(source)はfollowing
  has_many :followers, through: :passive_relationships, source: :following
  
  
  ## いまフォローしようとしているユーザーがフォローしているユーザー(followings)の中にいるか(= passive_relationships)
  def followed_by?(user)
    passive_relationships.find_by(following_id: user.id).present?
  end
  

  attachment :image
  

  # 退会フラグがfalseの時しかログインできないようにする
  def active_for_authentication?
    super && (self.is_deleted == false)
  end





end
