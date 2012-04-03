class SorceryCore < ActiveRecord::Migration
  def self.up
    change_table :users do |t|
      t.string :crypted_password, :default => nil
      t.string :salt,             :default => nil
    end
  end

  def self.down
    remove_column :users, :salt
    remove_column :users, :crypted_password
  end
end