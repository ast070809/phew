class CreateActivities < ActiveRecord::Migration
  def change
    create_table :activities do |t|
      t.integer :actor
      t.string :verb
      t.integer :object
      t.integer :target
      t.integer :user_id
      t.boolean :seen
      t.string :msg

      t.timestamps
    end
    add_index :activities, :id
    add_index :activities, :verb
    add_index :activities, :user_id
  end
end
