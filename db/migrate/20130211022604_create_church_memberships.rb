class CreateChurchMemberships < ActiveRecord::Migration
  def change
    create_table :church_memberships do |t|
      t.integer :user_id
      t.integer :church_id
      t.string :roles, default: "--- []"

      t.timestamps
    end
  end
end
