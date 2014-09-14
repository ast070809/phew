# == Schema Information
#
# Table name: activities
#
#  id         :integer          not null, primary key
#  actor      :integer
#  verb       :string(255)
#  object     :integer
#  target     :integer
#  user_id    :integer
#  seen       :boolean
#  msg        :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Activity < ActiveRecord::Base
  belongs_to :verb, polymorphic: true
  belongs_to :user
end
