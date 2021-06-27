class Post < ApplicationRecord

  validates :user_id, presence: true
  # validates :image, presence: true
  validates :caption, presence: true, length: { maximum: 200 }

  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :post_hashtags, dependent: :destroy
  has_many :hashtags, through: :post_hashtags
  has_many :post_images, dependent: :destroy
  accepts_attachments_for :post_images, attachment: :image
  has_many :notifications, dependent: :destroy

  def favorited_by?(user)
    favorites.where(user_id: user.id).exists?
  end

  # ランキング機能
  def self.create_ranking # Postクラスからデータを取ってくる処理なのでクラスメソッド
    Post.find(Favorite.group(:post_id).order('count(post_id) desc').limit(3).pluck(:post_id))
    ## Favoriteモデルの中から記事の番号(post_id)が同じものにグループを分ける → group(:post_id)
    ## 番号の多い順に並びかえる → order('count(post_id) desc') ：descは降順（多い順）になる
    ## 表示する数を3個に指定する → limit(3)
    ## カラムのみを数字で取り出すように指定 → pluck(:post_id)
    ## pluckで取り出される数字をPostのIDとすることでいいね順にpostを取得する事ができる → Post.find(pluckで取り出されたpost_id)
  end

  # タグ機能

  after_create do
    post = Post.find_by(id: id)
    hashtags = caption.scan(/[#＃][\w\p{Han}ぁ-ヶｦ-ﾟー]+/) # (\w 英数字, \p{Han} 漢字,ぁ-ヶ ひらがなカタカナ,ｦ-ﾟー 半角カタカナ)
    post.hashtags = []

    hashtags.uniq.map do |hashtag|
      # ハッシュタグは'#'を外した状態で保存
      tag = Hashtag.find_or_create_by(hashname: hashtag.downcase.delete('#'))
      post.hashtags << tag
    end
  end

  before_update do
    post = Post.find_by(id: id)
    post.hashtags.clear
    hashtags = caption.scan(/[#＃][\w\p{Han}ぁ-ヶｦ-ﾟー]+/)
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

  # 通知
  def create_notification_like!(current_user)
    ## すでに「いいね」されているか検索
    temp = Notification.where(["visitor_id = ? and visited_id = ? and post_id = ? and action = ?", current_user.id, user_id, id, 'like'])
                              ### ? = プレースホルダ、?を指定した値で置き換えることができるもの

    ## いいねされていない場合のみ、通知レコードを作成する
    if temp.blank?
      notification = current_user.active_notifications.new(
        post_id: id,
        visited_id: user_id,
        action: 'like'
      )
      ## 自分の投稿に対するいいねの場合は、通知済みとする
      if notification.visitor_id == notification.visited_id
        notification.checked = true
      end
      notification.save if notification.valid?
    end
  end


end
