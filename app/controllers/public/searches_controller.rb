class Public::SearchesController < ApplicationController
  before_action :authenticate_user!

  def search
    @search = params[:search]
    redirect_to request.referer if @search.blank? # キーワードが入力されていないと遷移元に
    split_keyword = params[:search].split(/[[:blank:]]+/) # splitで配列にして対応 blankは全角スペースの対応
    users = []
    posts = []

    split_keyword.each do |keyword|
      next if keyword == ""
      users += User.where("name LIKE ? OR user_name LIKE ?", "%#{keyword}%", "%#{keyword}%").order(created_at: :desc)
      posts += Post.where("caption LIKE ?", "%#{keyword}%").order(created_at: :desc)
      posts += Hashtag.where("hashname LIKE ?", "%#{keyword}%").order(created_at: :desc)
    end

    users.uniq! #uniqメソッド：配列の要素の中で重複している要素を削除して、削除後の配列として返す
    posts.uniq!
    
    @users = Kaminari.paginate_array(users).page(params[:page]).per(10)
    @posts = Kaminari.paginate_array(posts).page(params[:page]).per(12)
  end

end
