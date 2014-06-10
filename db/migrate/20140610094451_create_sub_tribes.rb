class CreateSubTribes < ActiveRecord::Migration
  def change
    create_table :sub_tribes do |t|
      t.string :name
      t.integer :tribe_id

      t.timestamps
    end
  end
end
