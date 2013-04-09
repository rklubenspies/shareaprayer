class RemoveEasyRoles < ActiveRecord::Migration
  def change
    remove_column :users, :roles
    remove_column :church_memberships, :roles
  end
end
