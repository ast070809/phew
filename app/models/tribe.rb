# == Schema Information
#
# Table name: tribes
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#  priority   :integer
#

class Tribe < ActiveRecord::Base
  has_and_belongs_to_many :users
  has_many :posts

  has_many :sub_tribes
end
