class UsersController < ApplicationController
	
	def show 
		links_per_page = 10
		@user = User.find(params[:id])
		@posts = @user.posts
        @posts = @posts.order('created_at desc').page(params[:page]).per(links_per_page)
	end
end
