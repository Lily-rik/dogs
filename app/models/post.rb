class Post < ApplicationRecord
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :post_hashtags, dependent: :destroy
  has_many :hashtags, through: :post_hashtags
  has_many :post_images, dependent: :destroy
  accepts_attachments_for :post_images, attachment: :image
  has_many :notifications, dependent: :destroy

  validates_associated :post_images

  validates :user_id, presence: true
  validates :post_images, presence: true, length: { maximum: 5 }
  validates :caption, presence: true, length: { maximum: 200 }



  def favorited_by?(user)
    favorites.where(user_id: user.id).exists?
  end

  # ランキング機能
  def self.create_ranking # Postクラスからデータを取ってくる処理なのでクラスメソッド
    Post.find(Favorite.group(:post_id).order('count(post_id) desc').limit(15).pluck(:post_id))
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
  def create_notification_favorite!(current_user)
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

  def create_notification_comment!(current_user, comment_id)
    ## 自分以外にコメントしている人をすべて取得し、全員に通知を送る
    temp_ids = Comment.select(:user_id).where(post_id: id).where.not(user_id: current_user.id).distinct
                      ### select(:user_id).where(post_id: id) = 投稿にコメントしているユーザーIDのリストを取得する
                      ### where.not(user_id: current_user.id) = 自分のコメントは除外する
                      ### distinct = 重複レコードを1つにまとめるためのメソッド、同じ通知が複数回登録されてしまうことを防ぐ
    temp_ids.each do |temp_id|
      save_notification_comment!(current_user, comment_id, temp_id['user_id'])
    end
    ## まだ誰もコメントしていない場合は、投稿者に通知を送る
      save_notification_comment!(current_user, comment_id, user_id) if temp_ids.blank?
  end

  def save_notification_comment!(current_user, comment_id, visited_id)
    ## コメントは複数回することが考えられるため、１つの投稿に複数回通知する
    notification = current_user.active_notifications.new(
      post_id: id,
      comment_id: comment_id,
      visited_id: visited_id,
      action: 'comment'
    )
    ## 自分の投稿に対するコメントの場合は、通知済みとする
    if notification.visitor_id == notification.visited_id
      notification.checked = true
    end
    notification.save if notification.valid?
  end



end
