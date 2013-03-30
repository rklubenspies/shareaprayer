class AddProviderAndProviderUidToUsers < ActiveRecord::Migration
  def up
    add_column :users, :provider, :string
    add_column :users, :provider_uid, :string
  end

  def down
    remove_column :users, :provider
    remove_column :user, :provider_uid
  end
end
