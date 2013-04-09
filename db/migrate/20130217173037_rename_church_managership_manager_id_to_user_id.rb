class RenameChurchManagershipManagerIdToUserId < ActiveRecord::Migration
  def change
    rename_column :church_managerships, :manager_id, :user_id
  end
end
