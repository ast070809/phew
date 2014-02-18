class ChangeHotnessPostsDatatype < ActiveRecord::Migration
  def up
  	remove_column :posts, :hotness
  end

  def down
  	add_column :posts, :hotness, :float
  end
end
