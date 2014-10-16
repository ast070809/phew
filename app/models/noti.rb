# == Schema Information
#
# Table name: notis
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  actor      :string(255)
#  verb       :string(255)
#  object     :integer
#  target     :string(255)
#  is_read    :boolean
#  created_at :datetime
#  updated_at :datetime
#

class Noti < ActiveRecord::Base

	belongs_to :user

	def self.add_noti(user, actor=nil, verb=nil, object = nil, target= nil)
		n = user.notis.new
		n.actor = actor
		n.verb = verb
		n.object = object
		n.target = target
		n.is_read = false
		if n.save
			user.urn +=1
			user.save
		end
	end
	
	def self.add_comment_noti(post_id, commenter_id)
		post_user = Post.find(post_id).user
		Noti.add_noti(post_user, commenter_id, 'post_comment', post_id, '')
	end

	def self.get_notis(user_id)
		u = User.find(user_id)
		u.notis(limit: 5, order: "updated_at DESC")
	end
end
