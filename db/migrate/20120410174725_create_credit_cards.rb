class CreateCreditCards < ActiveRecord::Migration
  def change
    create_table :credit_cards do |t|
      t.string :card_number
      t.string :expiration_month
      t.string :expiration_year
      t.string :ccv
      t.integer :user_id

      t.timestamps
    end
  end
end
