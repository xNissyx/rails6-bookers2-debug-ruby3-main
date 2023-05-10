class RoomsController < ApplicationController

  def create
    @room = Room.create(user_id: current_user.id)
    @entry1 = Entry.create(user_id: current_user.id, room_id: @room.id)
    @entry2 = Entry.create(entry_params)
    redirect_to room_path(@room.id)
  end

  def show
    @room = Room.find(params[:id])
    if Entry.where(user_id: current_user.id, room_id: @room.id).present?
      @messages = @room.messages
      @entries = @room.entries
      @message = Message.new
    else
      redirect_back(fallback_location: root_path)
    end
  end

  private

  def entry_params
    params.require(:entry).permit(:user_id, :room_id).merge(room_id: @room.id)
  end

end
