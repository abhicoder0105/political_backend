class CreatePrPosts < ActiveRecord::Migration[8.1]
  def change
    create_table :pr_posts do |t|
      t.string :title
      t.text :content
      t.string :language
      t.integer :status, null: false, default: 0
      t.datetime :scheduled_at
      t.datetime :published_at
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
