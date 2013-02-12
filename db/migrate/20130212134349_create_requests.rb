class CreateRequests < ActiveRecord::Migration
  def change
    create_table :requests do |t|
      t.string :text
      t.integer :user_id
      t.integer :church_id
      t.string :visibility
      t.boolean :anonymous
      t.string :ip_address

      t.timestamps
    end
  end
end
