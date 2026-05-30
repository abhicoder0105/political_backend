class ImprovePublicRequestsForAdminUx < ActiveRecord::Migration[8.1]
  def change
    add_column :public_requests, :internal_notes, :text
    add_column :public_requests, :public_response, :text
    add_column :public_requests, :expected_resolution_date, :date
    add_column :public_requests, :resolution_summary, :text
    add_column :public_requests, :escalated, :boolean, null: false, default: false
    add_reference :public_requests, :assigned_to_user, null: true, foreign_key: { to_table: :users }

    add_index :public_requests, :category
    add_index :public_requests, :area
    add_index :public_requests, :village_or_ward
    add_index :public_requests, :created_at
    add_index :public_requests, :escalated
  end
end
