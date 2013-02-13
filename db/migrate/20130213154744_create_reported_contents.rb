class CreateReportedContents < ActiveRecord::Migration
  def change
    create_table :reported_contents do |t|
      t.integer :reportable_id
      t.string :reportable_type
      t.integer :user_id
      t.string :reason
      t.integer :priority

      t.timestamps
    end
  end
end
