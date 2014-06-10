class AddSubTribeIdToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :sub_tribe_id, :integer
    add_index :posts, :sub_tribe_id
  end
end
