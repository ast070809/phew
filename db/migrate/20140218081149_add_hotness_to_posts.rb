class AddHotnessToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :hotness, :float
  end
end
