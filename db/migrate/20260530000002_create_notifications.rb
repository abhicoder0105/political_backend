class CreateNotifications < ActiveRecord::Migration[8.1]
  def change
    create_table :notifications do |t|
      t.references :user, null: false, foreign_key: true
      t.references :public_request, null: true, foreign_key: true
      t.string :title, null: false
      t.text :message, null: false
      t.string :notification_type
      t.integer :from_user_id
      t.boolean :read, default: false, null: false
      t.timestamps
    end

    add_foreign_key :notifications, :users, column: :from_user_id
    add_index :notifications, [:user_id, :read]
    add_index :notifications, :created_at
  end
end
