module PostsHelper

	def comment_count(post_id)
		post = Post.find(post_id)

		@root_comments = post.root_comments
    	rcount = @root_comments.count
	    c = 0
	    @root_comments.each do |r|
	      c += r.children.size
	    end
	    @com_count = c + rcount
	end
end
