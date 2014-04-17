# == Schema Information
#
# Table name: reports
#
#  id              :integer          not null, primary key
#  user_id         :integer
#  reportable_id   :integer
#  reportable_type :string(255)
#  created_at      :datetime
#  updated_at      :datetime
#

class Report < ActiveRecord::Base
	belongs_to :reportable, polymorphic: true
	
end
