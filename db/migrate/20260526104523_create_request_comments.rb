class CreateRequestComments < ActiveRecord::Migration[8.1]
  def change
    create_table :request_comments do |t|
      t.references :public_request, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.text :comment
      t.boolean :internal, null: false, default: true

      t.timestamps
    end
  end
end
