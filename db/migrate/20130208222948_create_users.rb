class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :roles, default: "--- []"
      t.integer :facebook_id, limit: 8
      t.string :facebook_token

      t.timestamps
    end
  end
end
