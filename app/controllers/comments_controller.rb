class CommentsController < ApplicationController
	def upvote
	    @comment = Comment.find(params[:id])
	    @comment.liked_by current_user
	    Comment.refresh_hotness(@comment)
	    Comment.refresh_votes(@comment)
	    redirect_to :back
  	end
  
	def downvote
	    @comment = Comment.find(params[:id])
	    @comment.downvote_from current_user
	    Comment.refresh_hotness(@comment)
	    Comment.refresh_votes(@comment)
	    redirect_to :back
	end

	def delete
		@comment = Comment.find(params[:id])
		@comment.destroy
		redirect_to :back
	end

end