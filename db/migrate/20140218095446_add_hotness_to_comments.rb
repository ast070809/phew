class AddHotnessToComments < ActiveRecord::Migration
  def change
    add_column :comments, :hotness, :float
  end
end
