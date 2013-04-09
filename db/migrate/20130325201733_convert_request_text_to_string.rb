class ConvertRequestTextToString < ActiveRecord::Migration
  def up
    change_column :requests, :text, :string, :limit => 10000
  end

  def down
    change_column :requests, :text, :text
  end
end
