class AddVipSubdomainUniqueIndex < ActiveRecord::Migration
  def up
    add_index :vip_signups, :subdomain, :unique => true
  end

  def down
    remove_index :vip_signups, :subdomain
  end
end
