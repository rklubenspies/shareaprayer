class AddPrayersCountToGroups < ActiveRecord::Migration
  def change
    add_column :groups, :prayers_count, :integer
  end
end
