class AddIdentifierToInvites < ActiveRecord::Migration
  def change
    add_column :invites, :identifier, :string
  end
end
