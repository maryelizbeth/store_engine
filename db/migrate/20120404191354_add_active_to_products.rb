class AddActiveToProducts < ActiveRecord::Migration
  def change
    add_column :products, :active, :boolean, :default => 1
  end
end
