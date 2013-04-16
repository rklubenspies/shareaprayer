class CreatePlans < ActiveRecord::Migration
  def change
    create_table :plans do |t|
      t.string :processor_uid
      t.integer :member_limit
      t.string :name
      t.string :description

      t.timestamps
    end
  end
end
