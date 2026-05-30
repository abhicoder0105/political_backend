class AddAssignmentFieldsToPublicRequests < ActiveRecord::Migration[8.1]
  def change
    add_column :public_requests, :assigned_by_id, :integer
    add_column :public_requests, :assigned_at, :datetime
    add_foreign_key :public_requests, :users, column: :assigned_by_id
    add_index :public_requests, :assigned_by_id
  end
end
