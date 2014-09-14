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

require 'test_helper'

class ReportTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
