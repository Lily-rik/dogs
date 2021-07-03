class Chat < ApplicationRecord

  validates :message, presence: true, length: { maximum: 100 }

  belongs_to :user
  belongs_to :room
  has_many :notifications, dependent: :destroy



  def create_notification_chat!(current_user, chat_id, visited_id)
    # コメントは複数回することが考えられるため、１つの投稿に複数回通知する
    notification = current_user.active_notifications.new(
      chat_id: chat_id,
      visited_id: visited_id,
      action: 'chat'
    )
    notification.save if notification.valid?
  end








end
