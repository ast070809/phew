class AddDefaultForUsers < ActiveRecord::Migration
  def up
  change_column :users, :urn, :integer, :default => 0
end

def down
  change_column :users, :urn, :integer, :default => nil
end
end
