class AddUrnToUsers < ActiveRecord::Migration
  def change
    add_column :users, :urn, :integer
  end
end
