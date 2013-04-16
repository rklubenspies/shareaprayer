class CreateSubscriptions < ActiveRecord::Migration
  def change
    create_table :subscriptions do |t|
      t.integer :plan_id
      t.integer :church_id
      t.string :processor_customer
      t.string :processor_payment_token
      t.string :processor_subscription
      t.string :state

      t.timestamps
    end
  end
end
