module ImageHelper
  POLITICIAN_BASE = "images/politicians/rakesh_shukla"

  def politician_image_path(category, filename)
    File.join("/", POLITICIAN_BASE, category.to_s, filename)
  end

  def fallback_banner_path
    politician_image_path("fallback", "fallback-banner.svg")
  end

  def fallback_thumbnail_path
    politician_image_path("fallback", "fallback-thumbnail.svg")
  end

  def profile_image_path(size = "main")
    politician_image_path("profile", "profile-#{size}.svg")
  end

  def banner_image_path(index = 0)
    banners = %w[hero-banner-1 hero-banner-2 hero-banner-3 hero-banner-4 hero-banner-5]
    key = banners[index % banners.size]
    politician_image_path("banners", "#{key}.svg")
  end

  def campaign_image_path(index = 0)
    campaigns = %w[
      campaign-solar-1 campaign-tree-plantation campaign-public-meeting-1
      campaign-women-empowerment campaign-kisan-samman
      campaign-cleanliness campaign-resolution
    ]
    key = campaigns[index % campaigns.size]
    politician_image_path("campaigns", "#{key}.svg")
  end

  def news_image_path(index = 0)
    news_items = %w[
      news-energy-initiative news-renewable-energy news-rural-development
      news-cleanliness-drive news-youth-employment news-education-reform
    ]
    key = news_items[index % news_items.size]
    politician_image_path("news", "#{key}.svg")
  end
end
