class CreatePostFeeds < ActiveRecord::Migration
  def change
    create_table :post_feeds do |t|
      t.integer :hot
      t.integer :top_today
      t.integer :top_week
      t.integer :top_all
      t.integer :latest

      t.timestamps
    end
  end
end
