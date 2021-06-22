class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  attachment :image
  # mount_uploader :picture, PictureUploader
  
  validates :email, presence: true
  validates :name, presence: true, length: { maximum: 10 }
  validates :telephone_number, presence: true, length: { in: 10..11 }
  validates :is_deleted, inclusion: { in: [true, false] }
  validates :user_name, presence: true, length: { maximum: 5 }


  with_options on: :mypage do
    validates :user_name, presence: true, length: { maximum: 5 }
    validates :image, presence: true
    validates :self_introduction, presence: true, length: { maximum: 100 }
  end



  # validates :image, presence: true
  # validates :self_introduction, presence: true, length: { maximum: 100 }



  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :user_rooms, dependent: :destroy
  has_many :chats, dependent: :destroy

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


  # 検索
  def self.looks(searchs)
    @user = User.where("name LIKE ? OR user_name LIKE ? OR email LIKE ?", "%#{searchs}%", "%#{searchs}%", "%#{searchs}%")
  end






end
