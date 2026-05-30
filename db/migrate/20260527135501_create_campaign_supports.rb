class CreateCampaignSupports < ActiveRecord::Migration[8.1]
  def change
    create_table :campaign_supports do |t|
      t.references :campaign, null: false, foreign_key: true
      t.string :name
      t.string :phone_number
      t.string :area
      t.string :village_or_ward
      t.text :message

      t.timestamps
    end
  end
end
