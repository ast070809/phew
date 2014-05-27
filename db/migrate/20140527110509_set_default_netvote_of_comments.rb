class SetDefaultNetvoteOfComments < ActiveRecord::Migration
  def change
  	change_column :comments, :netvote, :integer, :default => 0
  end
end
