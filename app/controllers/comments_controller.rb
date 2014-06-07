class CommentsController < ApplicationController
	def upvote
	    @comment = Comment.find(params[:id])
	    @comment.liked_by current_user
	    Comment.refresh_hotness(@comment)
	    Comment.refresh_votes(@comment)
	    #Pusher["private-#{@comment.user.id}"].trigger('comment_upvote', {:by => current_user.username, :id => @comment.id})
	    redirect_to :back
  	end
  
	def downvote
	    @comment = Comment.find(params[:id])
	    @comment.downvote_from current_user
	    Comment.refresh_hotness(@comment)
	    Comment.refresh_votes(@comment)
	    #Pusher['private-'+"#{current_user.id}"].trigger('comment_downvote', {:by => current_user.username, :id => @comment.id})
	    redirect_to :back
	end

	def delete
		@comment = Comment.find(params[:id])
		@comment.destroy
		redirect_to :back
	end

	def report_comment
	    comment_id = params[:id]
	    comment = Comment.find(comment_id)
	    r = comment.reports.find_or_create_by(user_id: current_user.id)
	    if r
	      flash[:success] = "Reported Successfully"
	    else
	      flash[:error] = "Some error occured"
	    end
	    redirect_to :back
  	end

end