class RenameUserIdToOwnerIdOnReportedContent < ActiveRecord::Migration
  def change
    rename_column :reported_contents, :user_id, :owner_id
  end
end
