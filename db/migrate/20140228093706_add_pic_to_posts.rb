class AddPicToPosts < ActiveRecord::Migration
  def self.up
    add_attachment :posts, :pic
  end

  def self.down
    remove_attachment :posts, :pic
  end
end
