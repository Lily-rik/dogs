class Post < ApplicationRecord


  validates :user_id, presence: true
  validates :image_id, presence: true
  validates :caption, presence: true, length: { maximum: 200 }



  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :favorites, dependent: :destroy

  attachment :image

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

end
