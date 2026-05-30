class AddImageUrlToCampaignsAndPrPosts < ActiveRecord::Migration[8.1]
  def change
    add_column :campaigns, :image_url, :string
    add_column :pr_posts, :image_url, :string
  end
end
