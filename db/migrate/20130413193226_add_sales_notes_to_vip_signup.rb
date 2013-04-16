class AddSalesNotesToVipSignup < ActiveRecord::Migration
  def up
    add_column :vip_signups, :sales_notes, :string
  end

  def down
    remove_column :vip_signups, :sales_notes
  end
end
