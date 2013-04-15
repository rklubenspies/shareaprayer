class AddHumanCostToPlans < ActiveRecord::Migration
  def up
    add_column :plans, :human_cost, :string
  end

  def down
    remove_column :plans, :human_cost
  end
end
