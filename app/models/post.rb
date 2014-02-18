# == Schema Information
#
# Table name: posts
#
#  id          :integer          not null, primary key
#  title       :text
#  link        :text
#  description :text
#  user_id     :integer
#  tribe_id    :integer
#  created_at  :datetime
#  updated_at  :datetime
#  hotness     :float
#

class Post < ActiveRecord::Base
	validates :title, presence: true
	validates :user_id, presence: true

	belongs_to :user
	
	has_many :comments

	acts_as_votable
	acts_as_commentable

	def self.refresh_hotness(post)
		hotness = Post.hot(post)
		post.hotness = hotness
		post.save
	end

	private
		def self.hot(post)
			# The hot formula
			ups = post.upvotes.size
			downs = post.downvotes.size
			date = post.created_at

			s = Post.score(ups,downs)
			order = Math.log10([s.abs,1].max)

			if s> 0
				sign = 1
			elsif s< 0
				sign = -1
			else 
				sign = 0
			end

			seconds = Post.epoch_seconds(date) - 1134028003
			return (sign*order + seconds/45000).round(7)
		end
		def self.epoch_seconds(date)
			epoch = DateTime.new(1988,1,1)
			# Returns the number of seconds from the epoch to date
			return date-epoch
		end

		def self.score(ups, downs)
			return ups-downs
		end

end
