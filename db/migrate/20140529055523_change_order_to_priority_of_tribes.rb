class ChangeOrderToPriorityOfTribes < ActiveRecord::Migration
  
  def self.up
    rename_column :tribes, :order, :priority
  end

  def self.down
    
  end
end
