class RelationshipsController < ApplicationController
  before_action :authenticate_user!

  def create
    followed_user = User.find(params[:user_id])
    current_user.follow(followed_user)
    redirect_back fallback_location: root_path
  end

  def destroy
    followed_user = User.find(params[:user_id])
    current_user.unfollow(followed_user)
    redirect_back fallback_location: root_path
  end
  
  def followings
    user = User.find(params[:user_id])
    @following_users = user.followings
  end
  
  def followers
    user = User.find(params[:user_id])
    @follower_users = user.followers
  end
end
