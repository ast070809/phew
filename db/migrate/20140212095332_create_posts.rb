class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.text :title
      t.text :link
      t.text :description
      t.integer :user_id
      t.integer :tribe_id

      t.timestamps
    end
  end
end
