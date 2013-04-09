class CreateVipSignups < ActiveRecord::Migration
  def change
    create_table :vip_signups do |t|
      t.string :code
      t.string :rep_uid
      t.string :name
      t.string :subdomain
      t.string :bio, :limit => 10000
      t.string :address
      t.string :phone
      t.string :website

      t.timestamps
    end
  end
end
