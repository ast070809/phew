# == Schema Information
#
# Table name: trending_tribes
#
#  id           :integer          not null, primary key
#  sub_tribe_id :integer
#  created_at   :datetime
#  updated_at   :datetime
#

class TrendingTribe < ActiveRecord::Base

	belongs_to :sub_tribe
	
end
