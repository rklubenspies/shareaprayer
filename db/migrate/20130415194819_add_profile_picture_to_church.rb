class AddProfilePictureToChurch < ActiveRecord::Migration
  def up
    add_column :churches, :profile_picture, :string
  end

  def down
    remove_column :churches, :profile_picture
  end
end
