class CreateWaitlists < ActiveRecord::Migration
  def change
    create_table :waitlists do |t|
      t.string :email

      t.timestamps
    end
  end
end
