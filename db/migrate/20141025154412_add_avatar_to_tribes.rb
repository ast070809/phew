class AddAvatarToTribes < ActiveRecord::Migration
  def self.up
    add_attachment :tribes, :avatar
  end

  def self.down
    remove_attachment :tribes, :avatar
  end
end
