class UsersController < ApplicationController
  before_action :set_user, only: %i(show edit update)
  before_action :ensure_correct_user, only: [:update, :edit]
  before_action :ensure_guest_user, only: [:edit]
    
  def show
    @books = @user.books
    @book = Book.new
    
    @today_count = @books.where("DATE(created_at) = ?", Date.today).count
    @yesterday_count = @books.where("DATE(created_at) = ?", Date.yesterday).count
    @week_count = 
    
    if @yesterday_count > 0
      @diff_percent = @today_count/@yesterday_count*100
    else
      @diff_percent = 0
    end
    # DM機能
    @currentUserEntry = Entry.where(user_id: current_user.id)
    @userEntry = Entry.where(user_id: @user.id)

    unless current_user == @user
      @currentUserEntry.each do |cu|
        @userEntry.each do |u|
          if cu.room_id == u.room_id
            @isRoom = true
            @roomId = cu.room_id
          end
        end
      end
      unless @isRoom
        @room = Room.new
        @entry = Entry.new
      end
    end
  end

  def index
    @users = User.all
    @book = Book.new
  end

  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to user_path(@user.id), notice: "You have updated user successfully."
    else
      render "edit"
    end
  end

  private

    def set_user
      @user = User.find(params[:id])
    end

    def user_params
      params.require(:user).permit(:name, :introduction, :profile_image)
    end

    def ensure_correct_user
      @user = User.find(params[:id])
      unless @user == current_user
        redirect_to user_path(current_user)
      end
    end
    
    def ensure_guest_user
      @user = User.find(params[:id])
      if @user.name == "guestuser"
        redirect_to user_path(@user)
      end
    end
end
