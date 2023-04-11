class ChangeInfectionDefaultValueToUsers < ActiveRecord::Migration[7.0]
  def up
    change_column :users, :infection, :boolean, default: false
  end
  
  def down
    change_column :users, :infection, :boolean, default: nil
  end
end
