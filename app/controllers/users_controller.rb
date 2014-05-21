class UsersController < ApplicationController
	
	def show 
		links_per_page = 10
		@user = User.find(params[:id])
		@posts = @user.posts
        @number_posts = @posts.count
        @posts = @posts.order('created_at desc').page(params[:page]).per(links_per_page)
		
		@comments = Comment.find_comments_by_user(@user).page(params[:pagina]).per(links_per_page)
		@number_comments = Comment.total_comments_of_user(@user)
	end
end
