class AddSubdomainToChurches < ActiveRecord::Migration
  def self.up
    add_column :churches, :subdomain, :string
    add_index :churches, :subdomain, unique: true
  end

  def self.down
    remove_column :churches, :subdomain
    remove_index :churches, :subdomain
  end
end
