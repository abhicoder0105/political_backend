class CreateVillageWards < ActiveRecord::Migration[8.1]
  def change
    create_table :village_wards do |t|
      t.string :name
      t.integer :kind, null: false, default: 0
      t.references :area, null: false, foreign_key: true

      t.timestamps
    end

    add_index :village_wards, [:area_id, :name], unique: true
  end
end
