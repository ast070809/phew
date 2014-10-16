class CreateNotis < ActiveRecord::Migration
  def change
    create_table :notis do |t|
      t.integer :user_id
      t.string :actor
      t.string :verb
      t.integer :object
      t.string :target
      t.boolean :is_read

      t.timestamps
    end
    add_index :notis, :user_id
  end
end
