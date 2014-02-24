class Tribeusers < ActiveRecord::Migration
  def change
    create_table :tribes_users, id: false do |t|
        t.belongs_to :user
     	t.belongs_to :tribe
    end
    add_index :tribes_users, [:user_id, :tribe_id]
  end
end
