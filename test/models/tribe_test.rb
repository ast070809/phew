# == Schema Information
#
# Table name: tribes
#
#  id                  :integer          not null, primary key
#  name                :string(255)
#  created_at          :datetime
#  updated_at          :datetime
#  priority            :integer
#  avatar_file_name    :string(255)
#  avatar_content_type :string(255)
#  avatar_file_size    :integer
#  avatar_updated_at   :datetime
#

require 'test_helper'

class TribeTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
