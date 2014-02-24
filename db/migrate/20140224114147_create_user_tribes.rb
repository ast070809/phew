class CreateUserTribes < ActiveRecord::Migration
  def change
    create_table :user_tribes, id: false do |t|
      t.integer :user_id
      t.integer :tribe_id

      t.timestamps
    end
  end
end
