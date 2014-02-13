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
#

class Post < ActiveRecord::Base
	validates :title, presence: true
	validates :user_id, presence: true
	validates :tribe_id, presence: true
	

	acts_as_commentable
end
