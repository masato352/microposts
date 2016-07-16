class RelationshipsController < ApplicationController

  before_action :logged_in_user

  #def show # 追加
   #@followings = @user.following_users(through: :following_relationships, source: :followed)
   #@followers = @user.follower_users(through: :follower_relationships, source: :follower)   
  #end  

  def create
    @user = User.find(params[:followed_id])
    current_user.follow(@user)
  end

  def destroy
    @user = current_user.following_relationships.find(params[:id]).followed
    current_user.unfollow(@user)
  end

end
