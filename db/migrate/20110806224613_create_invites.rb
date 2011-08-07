class CreateInvites < ActiveRecord::Migration
  def change
    create_table :invites do |t|
      t.string :email
      t.string :invite_code, :limit => 16
      t.datetime :invited_at
      t.datetime :redeemed_at
      
      t.timestamps
    end
  end
end
