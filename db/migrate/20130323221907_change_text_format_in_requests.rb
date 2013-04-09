class ChangeTextFormatInRequests < ActiveRecord::Migration
  def up
    change_column :requests, :text, :text
  end

  def down
    change_column :requests, :text, :string
  end
end
