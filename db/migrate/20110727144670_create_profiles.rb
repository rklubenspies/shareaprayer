class CreateProfiles < ActiveRecord::Migration
  def change
    create_table :profiles do |t|
      t.string :name
      t.text :bio
      t.string :image
      t.integer :user_id

      t.timestamps
    end
  end
end
