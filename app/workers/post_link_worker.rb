# app/workers/post_link.rb
class PostLinkWorker
  include Sidekiq::Worker
  

  def perform
	
	require 'stream'
	client = Stream::Client.new('nfmcbszq3yr2', 'v4ywctem9526yqt2gs245xem6qbrj6yxt8u332tum4gnm898x4aawetf8rceekjc')
  	# Instantiate a feed object
	user_feed_2 = client.feed('user:1')
	# Add an activity to the feed
	# Create a new activity
	activity_data = {:actor => 1, :verb => 'tweet', :object => 14, :tweet=> 'Hui Hui hui hui'}
	activity_response = user_feed_2.add_activity(activity_data)

	Pusher.url = "http://6b2448376d4955fa296c:77c911158c8bf9314a4b@api.pusherapp.com/apps/76475"
	Pusher['test_channel'].trigger('my_event', {
	  message: "not hello"
	})
  end
end