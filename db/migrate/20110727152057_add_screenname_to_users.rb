class AddScreennameToUsers < ActiveRecord::Migration
  def change
    add_column :users, :screenname, :string
  end
end
