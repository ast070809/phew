# == Schema Information
#
# Table name: posts
#
#  id               :integer          not null, primary key
#  title            :text
#  link             :text
#  description      :text
#  user_id          :integer
#  tribe_id         :integer
#  created_at       :datetime
#  updated_at       :datetime
#  hotness          :float
#  netvotes         :integer          default(0)
#  pic_file_name    :string(255)
#  pic_content_type :string(255)
#  pic_file_size    :integer
#  pic_updated_at   :datetime
#  source           :string(255)
#  sub_tribe_id     :integer
#  slug             :string(255)
#

require 'test_helper'

class PostTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
