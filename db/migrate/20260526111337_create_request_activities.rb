class CreateRequestActivities < ActiveRecord::Migration[8.1]
  def change
    create_table :request_activities do |t|
      t.references :public_request, null: false, foreign_key: true
      t.references :user, null: true, foreign_key: true
      t.string :action
      t.string :old_value
      t.string :new_value
      t.text :notes

      t.timestamps
    end
  end
end
