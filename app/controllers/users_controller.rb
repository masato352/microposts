class UsersController < ApplicationController
  def show # 追加
   @user = User.find(params[:id])
   @microposts = @user.microposts.order(created_at: :desc)
  end

  def show # 課題2で追加
   @user = User.find(params[:id])
    if @user == current_user
      render 'profile'
    else
      redirect_to @user
    end      
  end

  def new
    @user = User.new
    #@followings = Following.new    
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = "Welcome to the Sample App!"      
      redirect_to @user # ここを修正      
    else
      render 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
    
    if @user == current_user
      render 'edit'
    else
      redirect_to @user
    end
  end

  def update
    @user = User.find(params[:id]) 
    
    if @user.update(user_params)
      # 保存に成功した場合はトップページへリダイレクト
      redirect_to @user , notice: 'プロフィールを編集しました'
    else
      # 保存に失敗した場合は編集画面へ戻す
      render 'edit'
    end
  end

#課題2で追加
  def followings
   @user  = User.find(params[:id])
   @followings = @user.following_users
  end

  def followers
   @user  = User.find(params[:id])
   @followers = @user.follower_users
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password,
                                 :password_confirmation, :profile, :area )
  end  
  
end
