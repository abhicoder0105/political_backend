class CreateVidhansabhas < ActiveRecord::Migration[8.1]
  def change
    create_table :vidhansabhas do |t|
      t.string :name
      t.string :district
      t.string :state

      t.timestamps
    end

    add_index :vidhansabhas, :name, unique: true
  end
end
