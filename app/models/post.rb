class Post < ApplicationRecord

  attachment :image
  # mount_uploader :picture, PictureUploader

  validates :user_id, presence: true
  validates :image, presence: true
  validates :caption, presence: true, length: { maximum: 200 }

  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :post_hashtags, dependent: :destroy
  has_many :hashtags, through: :post_hashtags


  def favorited_by?(user)
    favorites.where(user_id: user.id).exists?
  end


 # ランキング機能
  def self.create_ranking  # Postクラスからデータを取ってくる処理なのでクラスメソッド
    Post.find(Favorite.group(:post_id).order('count(post_id) desc').limit(3).pluck(:post_id))
    ## Favoriteモデルの中から記事の番号(post_id)が同じものにグループを分ける → group(:post_id)
    ## 番号の多い順に並びかえる → order('count(post_id) desc') ：descは降順（多い順）になる
    ## 表示する数を3個に指定する → limit(3)
    ## カラムのみを数字で取り出すように指定 → pluck(:post_id)
    ## pluckで取り出される数字をPostのIDとすることでいいね順にpostを取得する事ができる → Post.find(pluckで取り出されたpost_id)
  end




  # タグ機能

  after_create do
    post = Post.find_by(id: self.id)
    hashtags = self.caption.scan(/[#＃][\w\p{Han}ぁ-ヶｦ-ﾟー]+/) # (\w 英数字, \p{Han} 漢字,ぁ-ヶ ひらがなカタカナ,ｦ-ﾟー 半角カタカナ)
    post.hashtags = []

    hashtags.uniq.map do |hashtag|
      # ハッシュタグは'#'を外した状態で保存
      tag = Hashtag.find_or_create_by(hashname: hashtag.downcase.delete('#'))
      post.hashtags << tag
    end
  end


  before_update do
    post = Post.find_by(id: self.id)
    post.hashtags.clear
    hashtags = self.caption.scan(/[#＃][\w\p{Han}ぁ-ヶｦ-ﾟー]+/)
    hashtags.uniq.map do |hashtag|
      tag = Hashtag.find_or_create_by(hashname: hashtag.downcase.delete('#'))
      post.hashtags << tag
    end
  end


  # 検索
  def self.looks(searchs)
    if searchs != "#"
      @post = Post.where("caption LIKE ?", "%#{searchs}%")
    end
  end




end
