class RenameVotesOfPosts < ActiveRecord::Migration
  def change
  	rename_column :posts, :votes, :netvotes
  end
end
