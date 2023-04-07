class CreateInfectionControls < ActiveRecord::Migration[7.0]
  def change
    create_table :infection_controls do |t|
      t.references :user, null: false, foreign_key: true
      t.text :authors, array: true, default: []

      t.timestamps
    end
  end
end
