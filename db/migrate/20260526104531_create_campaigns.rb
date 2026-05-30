class CreateCampaigns < ActiveRecord::Migration[8.1]
  def change
    create_table :campaigns do |t|
      t.string :title
      t.text :description
      t.string :language
      t.string :target_area
      t.string :target_village
      t.integer :target_support_status, null: false, default: 3
      t.datetime :scheduled_at
      t.integer :campaign_status, null: false, default: 0

      t.timestamps
    end
  end
end
