class UsersController < ApplicationController
	before_action :user_signed_in?, only: [:following, :followers ]
	include Feed

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

  	def get_feed  		
  		#feed = Rails.configuration.client.feed("notification:#{current_user.id}")
		#@user_feed = feed.get(:limit=>5, :offset=>0)  		
		#session[:feed_data] =@user_feed['results']
		#session[:unseen_feed] = @user_feed['unseen']
		#session[:feed_fetched] = true
		#@user_feed = session[:feed_data]
		@unread_msg = current_user.urn
		
		respond_to do |format|
	        format.js
      	end
  	end

  	def mark_read
  		#feed = Rails.configuration.client.feed("notification:#{current_user.id}")
  		#id = params[:id]
  		#@_feed = feed.get(:limit=>1,:id_lt=>id,:mark_seen=> true)
  		#@user_feed = feed.get(:limit=>5, :offset=>0)
  		#session[:feed_data] =@user_feed['results']
		#session[:unseen_feed] = @user_feed['unseen']
		#session[:feed_fetched] = true
		#@user_feed = session[:feed_data]
		n = Noti.find(params[:id])
		if n.update(is_read: true)
			u = n.user
			u.urn = u.urn - 1
			u.save
		end
		@urn = current_user.urn
  	end

end
