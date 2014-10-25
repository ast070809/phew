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

   has_attached_file :avatar, styles: {
    thumb: '100x100>',
    square: '200x200#',
    medium: '300x300>'
  }

  # Validate the attached image is image/jpg, image/png, etc
  validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/
end
