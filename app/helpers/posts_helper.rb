module PostsHelper
	include ActsAsTaggableOn::TagsHelper

	def top_comment(post_id)
		post = Post.find(post_id)

		@top_comment_arr = post.root_comments.order('netvote desc, created_at desc').limit(1)
		if @top_comment_arr.empty?
			@top_comment = nil
		else
			@top_comment = @top_comment_arr[0]
		end
	end

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

	def current_user_poster?(post)
		return true if post.user_id == current_user.id
	end
	


	def nested_li(objects, &block)
		objects = objects.order(:lft) if objects.is_a? Class

		return '' if objects.size == 0

		output = '<ul><li>'
		path = [nil]

		objects.each_with_index do |o, i|
		    if o.parent_id != path.last
		      # We are on a new level, did we descend or ascend?
		      if path.include?(o.parent_id)
		        # Remove the wrong trailing path elements
		        while path.last != o.parent_id
		          path.pop
		          output << '</li></ul>'
		        end
		        output << '</li><li>'
		      else
		        path << o.parent_id
		        output << '<ul><li>'
		      end
		    elsif i != 0
		      output << '</li><li>'
		    end
		    output << capture(o, path.size - 1, &block)
		  end

		  output << '</li></ul>' * path.length
		  output.html_safe
	end

	def refersh_hotness(post)
		hotness = hot(post)
		post.hotness = hotness
		post.save
	end

	
	private
		def hot(post)
			# The hot formula
			ups = post.upvotes.size
			downs = post.downvotes.size
			date = post.created_at

			s = score(ups,downs)
			order = Math.log10([s.abs,1].max)

			if s> 0
				sign = 1
			elsif s< 0
				sign = -1
			else 
				sign = 0
			end

			seconds = epoch_seconds(date) - 1134028003
			return (sign*order + seconds/45000).round(7)
		end

		def epoch_seconds(date)
			epoch = DateTime.new(1988,1,1)
			# Returns the number of seconds from the epoch to date
			return date-epoch
		end

		def score(ups, downs)
			return ups-downs
		end

end
