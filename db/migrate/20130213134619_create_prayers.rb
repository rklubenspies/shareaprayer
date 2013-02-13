class CreatePrayers < ActiveRecord::Migration
  def change
    create_table :prayers do |t|
      t.integer :user_id
      t.integer :request_id
      t.string :ip_address

      t.timestamps
    end
  end
end
