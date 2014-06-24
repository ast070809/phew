class StaticPagesController < ApplicationController

	def privacy_policy
	end

	def terms_of_use
	end

	def test
		
  	require 'pusher'
			Pusher.url = "http://6b2448376d4955fa296c:77c911158c8bf9314a4b@api.pusherapp.com/apps/76475"
	Pusher['test_channel'].trigger('my_event', {
	  message: "not hello"
	})
	end

end
