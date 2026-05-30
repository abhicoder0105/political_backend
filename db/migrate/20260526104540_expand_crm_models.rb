class ExpandCrmModels < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :phone_number, :string
    add_column :users, :address, :text
    add_column :users, :village_or_ward, :string
    add_column :users, :area, :string
    add_column :users, :rural_or_urban, :integer, null: false, default: 0
    add_column :users, :preferred_language, :string, null: false, default: "hi"

    add_column :public_requests, :request_title, :string
    add_reference :public_requests, :public_user, null: true, foreign_key: { to_table: :users }
    add_column :public_requests, :assigned_to, :string
    add_column :public_requests, :document_url, :string

    add_column :population_records, :full_name, :string
    add_column :population_records, :village, :string
    add_column :population_records, :ward, :string
    add_column :population_records, :booth_number, :string
    add_column :population_records, :voter_id, :string
    add_column :population_records, :aadhaar_document_url, :string
    add_column :population_records, :political_support_status, :integer, null: false, default: 3
    add_column :population_records, :assigned_worker, :string
    add_column :population_records, :political_engagement, :text

    add_column :work_dones, :category, :string
    add_column :work_dones, :area, :string
    add_column :work_dones, :village, :string
    add_column :work_dones, :budget, :decimal, precision: 12, scale: 2
    add_column :work_dones, :proof_images_url, :string
  end
end
