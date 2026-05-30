class CreateRequestHistories < ActiveRecord::Migration[8.1]
  def change
    create_table :request_histories do |t|
      t.references :public_request, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.string :from_status
      t.string :to_status
      t.text :note

      t.timestamps
    end
  end
end
