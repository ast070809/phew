class AddOrderToTribes < ActiveRecord::Migration
  def change
    add_column :tribes, :order, :integer
  end
end
