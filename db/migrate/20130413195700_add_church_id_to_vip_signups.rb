class AddChurchIdToVipSignups < ActiveRecord::Migration
  def up
    add_column :vip_signups, :church_id, :integer
  end

  def down
    remove_column :vip_signups, :church_id
  end
end
