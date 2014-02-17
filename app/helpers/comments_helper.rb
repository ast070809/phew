module CommentsHelper
	def current_user_commenter?(comment)
		return true if comment.user_id == current_user.id
	end
end