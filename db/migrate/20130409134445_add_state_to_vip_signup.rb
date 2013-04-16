class AddStateToVipSignup < ActiveRecord::Migration
  def up
    add_column :vip_signups, :state, :string
  end

  def down
    remove_column :vip_signups, :state
  end
end
