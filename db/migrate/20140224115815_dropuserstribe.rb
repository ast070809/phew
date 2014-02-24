class Dropuserstribe < ActiveRecord::Migration
  def change
  	drop_table :users_tribes
  end
end
