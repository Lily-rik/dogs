class Public::ChatsController < ApplicationController
  def show
    @user = User.find(params[:id])
    rooms = current_user.user_rooms.pluck(:room_id)
    user_rooms = UserRoom.find_by(user_id: @user.id, room_id: rooms)

    if user_rooms.nil?
      @room = Room.new
      @room.save
      UserRoom.create(user_id: current_user.id, room_id: @room.id)
      UserRoom.create(user_id: @user.id, room_id: @room.id)
    else
      @room = user_rooms.room
    end

    @chats = @room.chats.last(20)
    @chat = Chat.new(room_id: @room.id)
  end

  def create
    @user = User.find(params[:chat][:user_id])
    rooms = current_user.user_rooms.pluck(:room_id)
    user_rooms = UserRoom.find_by(user_id: @user.id, room_id: rooms)
    @room = user_rooms.room
    @chats = @room.chats

    @chat = current_user.chats.new(chat_params)
    @chat.save
    @chat.create_notification_chat!(current_user, @chat.id, @user.id) # 通知
  end






  private

  def chat_params
    params.require(:chat).permit(:message, :room_id, :user_id)
  end
end
