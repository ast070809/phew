class RenameVotesToNetvoteComment < ActiveRecord::Migration
  def self.up
    rename_column :comments, :votes, :netvote
  end
  def self.down
  end
end
