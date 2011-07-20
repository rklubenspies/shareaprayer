class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :provider
      t.string :uid
      t.string :token
      t.string :name
      t.string :email
      t.string :screenname
      t.text :bio
      t.string :religion
      t.string :political
      t.string :image
      t.string :provider_profile

      t.timestamps
    end
  end
end
