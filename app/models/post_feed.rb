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

class PostFeed < ActiveRecord::Base
end
