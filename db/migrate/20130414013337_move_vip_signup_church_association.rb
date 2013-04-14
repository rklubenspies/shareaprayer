class MoveVipSignupChurchAssociation < ActiveRecord::Migration
  def up
    add_column :churches, :vip_signup_id, :integer
    remove_column :vip_signups, :church_id
  end

  def down
    remove_column :churches, :vip_signup_id
    add_column :vip_signups, :church_id, :integer
  end
end
