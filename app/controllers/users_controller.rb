class UsersController < ApplicationController
	before_action :user_signed_in?, only: [:following, :followers ]
	def show 
		links_per_page = 10
		@user = User.friendly.find(params[:id])
		if request.path != user_path(@user)
			redirect_to @user, status: :moved_permanently
		end

		@posts = @user.posts
        @number_posts = @posts.count
        @posts = @posts.order('created_at desc').page(params[:page]).per(links_per_page)
		@comments = Comment.find_comments_by_user(@user).page(params[:pagina]).per(links_per_page)
		@number_comments = Comment.total_comments_of_user(@user)
	end

	def following
	    @title = "Following"
	    @user = User.friendly.find(params[:id])
	    @users = @user.followed_users.page(params[:page]).per(10)
	    render 'show_follow'
  	end

  	def followers
	    @title = "Followers"
	    @user = User.friendly.find(params[:id])
	    @users = @user.followers.page(params[:page]).per(10)
	    render 'show_follow'
  	end

end
