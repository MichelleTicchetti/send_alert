class AddSpecificUserToAlerts < ActiveRecord::Migration[7.2]
  def change
    add_column :alerts, :specific_user, :boolean, default: false
  end
end
