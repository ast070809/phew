# == Schema Information
#
# Table name: posts
#
#  id               :integer          not null, primary key
#  title            :text
#  link             :text
#  description      :text
#  user_id          :integer
#  tribe_id         :integer
#  created_at       :datetime
#  updated_at       :datetime
#  hotness          :float
#  netvotes         :integer          default(0)
#  pic_file_name    :string(255)
#  pic_content_type :string(255)
#  pic_file_size    :integer
#  pic_updated_at   :datetime
#  source           :string(255)
#

class Post < ActiveRecord::Base
	
	has_attached_file :pic, styles: {
	    thumb: '100x100#',
	    square: '200x200#',
	    medium: '300x300>'
  	}
  	
  	# Validate the attached image is image/jpg, image/png, etc
 	validates_attachment_content_type :pic, :content_type => /\Aimage\/.*\Z/
 	
	validates :title, presence: true
	validates :user_id, presence: true
	
	belongs_to :user
	belongs_to :tribe
		
	has_many :comments

	has_many :reports, as: :reportable
	acts_as_votable
	acts_as_commentable
	acts_as_taggable_on :tags

	def self.refresh_hotness(post)
		hotness = Post.hot(post)
		post.hotness = hotness
		post.save
	end

	def self.today
	  where("created_at >= ?", Time.zone.now.beginning_of_day)
	end
	
	def self.week
	  where("created_at >= ?", Time.zone.now.beginning_of_week)
	end

	def self.month
	  where("created_at >= ?", Time.zone.now.beginning_of_month)
	end

	def self.year
	  where("created_at >= ?", Time.zone.now.beginning_of_year)
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
