class CreateChurchManagerships < ActiveRecord::Migration
  def change
    create_table :church_managerships do |t|
      t.integer :church_id
      t.integer :manager_id

      t.timestamps
    end
  end
end
