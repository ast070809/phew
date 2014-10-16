module Feed
	def self.add_comment_notification(post_id, actor_id)
		post = Post.find(post_id)
		post_user = post.user
		if post_user.id != actor_id
			post_user.notify(subj='post_comment', body='actor_id', obj= post, sanitize_text =true, notification_code = 1, send_mail = false)
			post_user.urn = post_user.urn + 1
			post_user.save 
		end
	end	
end