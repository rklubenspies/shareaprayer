class CreateChurchProfiles < ActiveRecord::Migration
  def change
    create_table :church_profiles do |t|
      t.text :bio
      t.string :address
      t.string :phone
      t.string :email
      t.string :website
      t.integer :church_id

      t.timestamps
    end
  end
end
