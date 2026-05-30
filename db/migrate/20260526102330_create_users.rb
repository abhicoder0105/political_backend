class CreateUsers < ActiveRecord::Migration[8.1]
  def change
    create_table :users do |t|
      t.string :name
      t.string :mobile_number
      t.integer :role, null: false, default: 3
      t.string :password_digest
      t.string :otp_code
      t.datetime :otp_requested_at

      t.timestamps
    end

    add_index :users, :mobile_number, unique: true
  end
end
