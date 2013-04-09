class AddIpAddressToReportedContent < ActiveRecord::Migration
  def change
    add_column :reported_contents, :ip_address, :string
  end
end
