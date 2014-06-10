# == Schema Information
#
# Table name: sub_tribes
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  tribe_id   :integer
#  created_at :datetime
#  updated_at :datetime
#

class SubTribe < ActiveRecord::Base

	has_many :trending_tribes
	has_many :posts
	belongs_to :tribe
	
end
