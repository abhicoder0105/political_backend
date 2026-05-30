class CreatePermissions < ActiveRecord::Migration[8.1]
  def change
    create_table :permissions do |t|
      t.string :key
      t.string :name
      t.text :description

      t.timestamps
    end

    add_index :permissions, :key, unique: true
  end
end
