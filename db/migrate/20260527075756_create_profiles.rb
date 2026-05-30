class CreateProfiles < ActiveRecord::Migration[8.1]
  def change
    create_table :profiles do |t|
      t.string :name
      t.string :title
      t.string :party
      t.string :constituency
      t.string :department
      t.text :biography
      t.text :political_experience
      t.text :focus_areas
      t.text :contact_info
      t.string :image_url

      t.timestamps
    end
  end
end
