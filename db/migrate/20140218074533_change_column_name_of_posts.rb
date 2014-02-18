class ChangeColumnNameOfPosts < ActiveRecord::Migration
  def change
  	change_table :posts do |t|
      t.rename :score, :hotness
  	end
  end
end
