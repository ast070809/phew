class CommentsController < ApplicationController
	def upvote
	    @comment = Comment.find(params[:id])
	    @comment.liked_by current_user
	    redirect_to :back
  	end
  
	def downvote
	    @comment = Comment.find(params[:id])
	    @comment.downvote_from current_user
	    redirect_to :back
	end
end