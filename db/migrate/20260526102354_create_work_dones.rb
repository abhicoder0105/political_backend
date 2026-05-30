class CreateWorkDones < ActiveRecord::Migration[8.1]
  def change
    create_table :work_dones do |t|
      t.references :population_record, null: false, foreign_key: true
      t.string :title
      t.string :work_type
      t.text :description
      t.integer :status, null: false, default: 0
      t.string :assigned_to
      t.datetime :completed_at
      t.string :proof_image_url
      t.text :remarks

      t.timestamps
    end
  end
end
