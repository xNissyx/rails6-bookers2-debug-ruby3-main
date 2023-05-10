class MessagesController < ApplicationController

  def show
     @user = User.find(params[:id])
     rooms = current_user.entries.pluck(:room_id)
     user_rooms = Entry.find_by(user_id: @user.id, room_id: rooms)

    # unless user_rooms.nil?#ユーザールームが無くなかった（つまりあった。）
    #   @room = entries.room #変数@roomにユーザー（自分と相手）と紐づいているroomを代入
    # else#ユーザールームが無かった場合
    #   @room = Room.new #新しくRoomを作る
    #   @room.save #そして保存
    #   Entry.create(user_id: current_user.id, room_id: @room.id) #自分の中間テーブルを作る
    #   Entry.create(user_id: @user.id, room_id: @room.id) #相手の中間テーブルを作る
    # end
    # @chats = @room.chats #チャットの一覧用の変数
    # @chat = Chat.new(room_id: @room.id) #チャットの投稿用の変数
  end

  def create
    @message = current_user.messages.new(message_params)
    @messages = Message.where(user_id: current_user.id)
    if @message.save
      # redirect_to books_path, notice: "メッセージを送信しました。"
    else
      @books = Book.all
      redirect_to books_path
    end
  end

  private

  def message_params
    params.require(:message).permit(:message, :room_id)
  end
end