class GroupsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_correct_user, only: %i(edit update)
    
  def new
    @group = Group.new
  end

  def create
    @group = Group.new(group_params)
    @group.owner_id = current_user.id
    @group.users << current_user
    if @group.save
      redirect_to groups_path
    else
      render "new"
    end
  end
  
  def show
    @group = Group.find(params[:id])
    @book = Book.new
  end

  def index
    @book = Book.new
    @groups = Group.all
  end
  
  # グループ参加機能
  def join
    @group = Group.find_by(id: params[:group_id])
    @group.users << current_user
    redirect_to  groups_path
  end

  def edit
    @group = Group.find(params[:id])
  end
  
  def update
    @group = Group.find(params[:id])
    if @group.update(group_params)
      redirect_to groups_path
    else
      render "edit"
    end
  end
  
  def destroy
    # グループ除名機能
    @group = Group.find(params[:id])
    @group.users.delete(current_user)
    redirect_to groups_path
  end

  private
  def group_params
    params.require(:group).permit(:name, :introduction, :image)
  end
  def ensure_correct_user
    @group = Group.find(params[:id])
    if @group.owner_id != current_user.id
      redirect_to groups_path
    end
  end
end







#   before_action :authenticate_user!
#   before_action :ensure_correct_user, only: [:edit, :update]

#   def new
#     @group =Group.new
#   end

#   def index
#     @book = Book.new
#     @groups = Group.all
#   end

#   def show
#     @book = Book.new
#     @group = Group.find(params[:id])
#   end

#   def create
#     @group = Group.new(group_params)
#     @group.owner_id = current_user.id
#     if @group.save
#       redirect_to groups_path
#     else
#       render 'new'
#     end

#   end

#   def edit
#   end

#   def update
#     if @group.update(group_params)
#       redirect_to groups_path
#     else
#       render "edit"
#     end
#   end

#   private

#   def group_params
#     params.require(:group).permit(:name, :introduction, :image)
#   end

#   def ensure_correct_user
#     @group = Group.find(params[:id])
#     unless @group.owner_id == current_user.id
#       redirect_to groups_path
#     end
#   end
# end
