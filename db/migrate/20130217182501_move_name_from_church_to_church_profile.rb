class MoveNameFromChurchToChurchProfile < ActiveRecord::Migration
  def change
    remove_column :churches, :name
    add_column :church_profiles, :name, :string
  end
end
