class UsersController < ApplicationController
  before_action :set_user, only: [:edit, :update]
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy,
                                        :followings, :followers]
  before_action :admin_user, only: :destroy

  def index
    @user = User.new
  end

  def show
   @user = User.find(params[:id])
   @microposts = @user.microposts.order(created_at: :desc)
  end
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = "Welcome to the Sample App!"
      session[:user_id] = @user.id
      redirect_to @user
    else
      render 'new'
    end
  end
  
  def edit
    if current_user != @user
      redirect_to root_path
    end
  end
  
  def update
    if current_user != @user
      redirect_to root_path
      return
    end
    if @user.update(user_params)
      # 保存に成功した場合はトップページへリダイレクト
      render 'show', notice: 'メッセージを編集しました'
    else
      # 保存に失敗した場合は編集画面へ戻す
      render 'edit'
    end
  end
  
  def followings
    @title = "Followings"
    @user  = User.find(params[:id])
    @users = @user.following_users
    render 'show_follow'
  end

  def followers
    @title = "Followers"
    @user  = User.find(params[:id])
    @users = @user.follower_users
    render 'show_follow'
  end
  
  def favorite
    @title = 'Favorite Microposts'
    @user  = User.find(params[:id])
    @micropost = @user.microposts.build
    @feed_favorites = @user.favorite_microposts.page params[:page]
    render 'show_favorite'
  end
  
  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to users_url
  end
  
  private
    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end

  def user_params
    params.require(:user).permit(:name, :email, :introduction, :place, :homepage, :birthday, :password,
                                 :password_confirmation)
  end
  
  def set_user
    @user = User.find(params[:id])
  end
end
