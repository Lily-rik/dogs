class Public::NotificationsController < ApplicationController

  def index
    @notifications = current_user.passive_notifications.page(params[:page]).per(10)
    # 未確認の通知(false)のものを確認済み(true)に変更する
    @notifications.where(checked: false).each do |notification|
      notification.update_attributes(checked: true) # update_attributes = データベースの値を複数同時に更新するメソッド
    end
  end

end