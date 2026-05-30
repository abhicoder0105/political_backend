class CreatePublicRequests < ActiveRecord::Migration[8.1]
  def change
    create_table :public_requests do |t|
      t.string :name
      t.string :phone_number
      t.string :area
      t.string :village_or_ward
      t.string :category
      t.text :description
      t.string :image_url
      t.integer :severity, null: false, default: 1
      t.integer :status, null: false, default: 0

      t.timestamps
    end

    add_index :public_requests, :phone_number
    add_index :public_requests, :status
    add_index :public_requests, :severity
  end
end
