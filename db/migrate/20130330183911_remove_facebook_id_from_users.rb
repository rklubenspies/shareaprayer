class RemoveFacebookIdFromUsers < ActiveRecord::Migration
  def up
    remove_column :users, :facebook_id
  end

  def down
    add_column :users, :facebook_id, :string
  end
end
