class AddPrayersCountToUsers < ActiveRecord::Migration
  def change
    add_column :users, :prayers_count, :integer
  end
end
