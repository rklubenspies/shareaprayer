class AddPlanIdToVipSignups < ActiveRecord::Migration
  def up
    add_column :vip_signups, :plan_id, :integer
  end

  def remove
    remove_column :vip_signups, :plan_id
  end
end
