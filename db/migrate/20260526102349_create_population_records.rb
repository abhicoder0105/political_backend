class CreatePopulationRecords < ActiveRecord::Migration[8.1]
  def change
    create_table :population_records do |t|
      t.string :name
      t.integer :age
      t.integer :gender, null: false, default: 0
      t.string :phone_number
      t.text :address
      t.string :area
      t.string :village_or_ward
      t.integer :rural_or_urban, null: false, default: 0
      t.integer :family_count, null: false, default: 1
      t.string :aadhaar_image_url
      t.boolean :whatsapp_consent, null: false, default: false
      t.text :notes
      t.text :tags
      t.references :vidhansabha, null: true, foreign_key: true
      t.references :area_ref, null: true, foreign_key: { to_table: :areas }
      t.references :village_ward, null: true, foreign_key: true

      t.timestamps
    end

    add_index :population_records, :phone_number
    add_index :population_records, :area
    add_index :population_records, :village_or_ward
    add_index :population_records, :rural_or_urban
    add_index :population_records, :gender
  end
end
