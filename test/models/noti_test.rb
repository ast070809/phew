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

require 'test_helper'

class NotiTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
