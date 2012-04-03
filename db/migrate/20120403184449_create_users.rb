class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :full_name
      t.string :email_address
      t.string :display_name

      t.timestamps
    end
  end
end
