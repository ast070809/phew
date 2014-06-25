class StaticPagesController < ApplicationController

	def privacy_policy
	end

	def terms_of_use
	end

	def test

		post = Post.first
		post.delay.test_notify

	end

end
