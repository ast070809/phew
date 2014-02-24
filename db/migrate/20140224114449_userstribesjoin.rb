class Userstribesjoin < ActiveRecord::Migration
  def change
    create_table :users_tribes, id: false do |t|
      t.integer :user_id
      t.integer :tribe_id
    end
  end
end
