class CreateTrendingTribes < ActiveRecord::Migration
  def change
    create_table :trending_tribes do |t|
      t.integer :sub_tribe_id
      t.timestamps
    end
  end
end
