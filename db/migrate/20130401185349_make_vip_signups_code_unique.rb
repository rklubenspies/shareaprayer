class MakeVipSignupsCodeUnique < ActiveRecord::Migration
  def up
    add_index :vip_signups, :code, :unique => true
  end

  def down
    remove_index :vip_signups, :code
  end
end
