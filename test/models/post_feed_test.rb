# == Schema Information
#
# Table name: post_feeds
#
#  id         :integer          not null, primary key
#  hot        :integer
#  top_today  :integer
#  top_week   :integer
#  top_all    :integer
#  latest     :integer
#  created_at :datetime
#  updated_at :datetime
#

require 'test_helper'

class PostFeedTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
