class StaticPagesController < ApplicationController

	def privacy_policy
	end

	def terms_of_use
	end

	def test
		
		# Instantiate a feed object
		user_feed_1 = Rails.configuration.client.feed('user:1')
		# Add an activity to the feed
		# Create a new activity
		activity_data = {:actor => 1, :verb => 'tweet', :object => 1}
		@activity_response = user_feed_1.add_activity(activity_data)
	end

end
