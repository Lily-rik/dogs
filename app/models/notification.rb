class Notification < ApplicationRecord
  
  # デフォルトの並び順を「作成日時の降順」で指定 = 常に新しい通知からデータを取得することができる
  default_scope -> { order(created_at: :desc) }
  
  belongs_to :post, optional: true
  belongs_to :comment, optional: true
  belongs_to :chat, optional: true
  
  belongs_to :visitor, foreign_key: 'visitor_id', class_name: 'User', optional: true # optional: trueはnilを許可するもの
  belongs_to :visited, foreign_key: 'visited_id', class_name: 'User', optional: true # belongs_toはnilが許可されないが、今回はnilを設定したいため追加する
  
  
end
