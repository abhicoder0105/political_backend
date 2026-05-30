class CreateAreas < ActiveRecord::Migration[8.1]
  def change
    create_table :areas do |t|
      t.string :name
      t.references :vidhansabha, null: false, foreign_key: true

      t.timestamps
    end

    add_index :areas, [:vidhansabha_id, :name], unique: true
  end
end
