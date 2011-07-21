class CreatePrayers < ActiveRecord::Migration
  def change
    create_table :prayers do |t|
      t.integer :user_id
      t.integer :group_id
      t.text :prayer
      t.boolean :facebook_share
      t.string :source

      t.timestamps
    end
  end
end
